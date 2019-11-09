import Foundation
import PromiseKit

final class DefaultTextStylesGenerator: TextStylesGenerator, GeneratorParametersResolving {

    // MARK: - Instance Properties

    let textStylesProvider: TextStylesProvider
    let textStylesEncoder: TextStylesEncoder
    let templateRenderer: TemplateRenderer

    // MARK: - GeneratorParametersResolver

    let defaultTemplateType = RenderTemplateType.native(name: "TextStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        textStylesProvider: TextStylesProvider,
        textStylesEncoder: TextStylesEncoder,
        templateRenderer: TemplateRenderer
    ) {
        self.textStylesProvider = textStylesProvider
        self.textStylesEncoder = textStylesEncoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GeneratorParameters) -> Promise<Void> {
        return firstly {
            self.textStylesProvider.fetchTextStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.map { textStyles in
            self.textStylesEncoder.encodeTextStyles(textStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.template,
                to: parameters.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: TextStylesConfiguration) -> Promise<Void> {
        return firstly {
            self.generate(parameters: try self.resolveGeneratorParameters(from: configuration))
        }
    }
}
