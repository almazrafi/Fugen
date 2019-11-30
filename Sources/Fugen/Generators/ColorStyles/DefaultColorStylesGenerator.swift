import Foundation
import FugenTools
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let colorStylesCoder: ColorStylesCoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        colorStylesCoder: ColorStylesCoder,
        templateRenderer: TemplateRenderer
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.colorStylesCoder = colorStylesCoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, assets: String?) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(from: parameters.file, nodes: parameters.nodes, assets: assets)
        }.done { colorStyles in
            let context = self.colorStylesCoder.encodeColorStyles(colorStyles)

            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: ColorStylesConfiguration) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration.generatation)
        }.then { parameters in
            self.generate(parameters: parameters, assets: configuration.assets)
        }
    }
}
