import Foundation
import FugenTools
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(colorStylesProvider: ColorStylesProvider, templateRenderer: TemplateRenderer) {
        self.colorStylesProvider = colorStylesProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, assets: String?) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(
                from: parameters.file,
                nodes: parameters.nodes,
                assets: assets
            )
        }.map { colorStyles in
            ColorStylesContext(colorStyles: colorStyles)
        }.done { context in
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
            try self.resolveGenerationParameters(from: configuration.generation)
        }.then { parameters in
            self.generate(parameters: parameters, assets: configuration.assets)
        }
    }
}
