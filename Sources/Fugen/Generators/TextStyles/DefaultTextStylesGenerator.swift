import Foundation
import PromiseKit

final class DefaultTextStylesGenerator: TextStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let textStylesProvider: TextStylesProvider
    let textStylesCoder: TextStylesCoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "TextStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        textStylesProvider: TextStylesProvider,
        textStylesCoder: TextStylesCoder,
        templateRenderer: TemplateRenderer
    ) {
        self.textStylesProvider = textStylesProvider
        self.textStylesCoder = textStylesCoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) -> Promise<Void> {
        return firstly {
            self.textStylesProvider.fetchTextStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.done { textStyles in
            let context = self.textStylesCoder.encodeTextStyles(textStyles)

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
            self.generate(parameters: try self.resolveGenerationParameters(from: configuration))
        }
    }
}
