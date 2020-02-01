import Foundation
import FugenTools
import PromiseKit

final class DefaultTextStylesGenerator: TextStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let textStylesProvider: TextStylesProvider
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "TextStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(textStylesProvider: TextStylesProvider, templateRenderer: TemplateRenderer) {
        self.textStylesProvider = textStylesProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) -> Promise<Void> {
        return firstly {
            self.textStylesProvider.fetchTextStyles(from: parameters.file, nodes: parameters.nodes)
        }.map { textStyles in
            TextStylesContext(textStyles: textStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: TextStylesConfiguration) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration)
        }.then { parameters in
            self.generate(parameters: parameters)
        }
    }
}
