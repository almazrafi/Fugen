import Foundation
import SwiftCLI
import PathKit
import PromiseKit
import FugenTools

final class TextStylesCommand: Command {

    // MARK: - Instance Properties

    let name = "textStyles"
    let shortDescription = "Generates code for text styles from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate text styles from.
            """
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let includingNodeIDs = VariadicKey<String>(
        "--including",
        "-i",
        description: #"""
            A list of nodes whose styles will be extracted.
            Can be repeated multiple times and must be in the format: -i "1:23".
            If omitted, all nodes will be included.
            """#
    )

    let excludingNodeIDs = VariadicKey<String>(
        "--excluding",
        "-e",
        description: #"""
            A list of nodes whose styles will be ignored.
            Can be repeated multiple times and must be in the format: -e "1:23".
            """#
    )

    let renderTemplatePath = Key<String>(
        "--templatePath",
        "-t",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let renderTemplateOptions = VariadicKey<String>(
        "--options",
        "-o",
        description: #"""
           An option that will be merged with template context, and overwrite any values of the same name.
           Can be repeated multiple times and must be in the format: -o "name:value".
           """#
    )

    let renderDestinationPath = Key<String>(
        "--destinationPath",
        "-d",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    let dependencies: TextStylesDependencies

    // MARK: - Initializers

    init(dependencies: TextStylesDependencies) {
        self.dependencies = dependencies
    }

    // MARK: - Instance Methods

    private func resolveRenderTemplate() -> RenderTemplate {
        let renderTemplateType: RenderTemplateType

        if let renderTemplatePath = self.renderTemplatePath.value {
            renderTemplateType = .custom(path: renderTemplatePath)
        } else {
            renderTemplateType = .native(name: "TextStyles")
        }

        var renderTemplateOptions: [String: String] = [:]

        for renderTemplateOption in self.renderTemplateOptions.value {
            var components = renderTemplateOption.components(separatedBy: ":")

            guard components.count > 1 else {
                fail(message: "Invalid format of options argument '\(renderTemplateOption)'")
            }

            let optionKey = components.removeFirst().trimmingCharacters(in: .whitespaces)
            let optionValue = components.joined(separator: ":")

            renderTemplateOptions[optionKey] = optionValue
        }

        return RenderTemplate(
            type: renderTemplateType,
            options: renderTemplateOptions
        )
    }

    private func resolveRenderDestination() -> RenderDestination {
        if let renderDestinationPath = self.renderDestinationPath.value {
            return .file(path: renderDestinationPath)
        } else {
            return .console
        }
    }

    // MARK: -

    func execute() throws {
        guard let fileKey = fileKey.value, !fileKey.isEmpty else {
            fail(message: "Figma file key is missing or empty")
        }

        guard let accessToken = accessToken.value, !accessToken.isEmpty else {
            fail(message: "Figma access token is missing or empty")
        }

        let includingNodeIDs = self.includingNodeIDs.value
        let excludingNodeIDs = self.excludingNodeIDs.value

        let renderTemplate = resolveRenderTemplate()
        let renderDestination = resolveRenderDestination()

        let textStylesProvider = dependencies.makeTextStylesProvider()
        let textStylesEncoder = dependencies.makeTextStylesEncoder()
        let templateRenderer = dependencies.makeTemplateRenderer()

        firstly {
            textStylesProvider.fetchTextStyles(
                fileKey: fileKey,
                accessToken: accessToken,
                includingNodes: includingNodeIDs,
                excludingNodes: excludingNodeIDs
            )
        }.map { textStyles in
            textStylesEncoder.encodeTextStyles(textStyles)
        }.done { context in
            try templateRenderer.renderTemplate(
                renderTemplate,
                to: renderDestination,
                context: context
            )

            self.success(message: "Text styles generation completed successfully!")
        }.catch { error in
            self.fail(error: error)
        }

        RunLoop.main.run()
    }
}
