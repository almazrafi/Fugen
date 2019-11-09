import Foundation
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GeneratorParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let colorStylesEncoder: ColorStylesEncoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        colorStylesEncoder: ColorStylesEncoder,
        templateRenderer: TemplateRenderer
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.colorStylesEncoder = colorStylesEncoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GeneratorParameters) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.map { colorStyles in
            self.colorStylesEncoder.encodeColorStyles(colorStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.template,
                to: parameters.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: ColorStylesConfiguration) -> Promise<Void> {
        return firstly {
            self.generate(parameters: try self.resolveGeneratorParameters(from: configuration))
        }
    }
}
