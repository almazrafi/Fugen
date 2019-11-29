import Foundation
import FugenTools
import PromiseKit

final class DefaultColorStylesGenerator: ColorStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let assetsProvider: AssetsProvider
    let colorStylesCoder: ColorStylesCoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        assetsProvider: AssetsProvider,
        colorStylesCoder: ColorStylesCoder,
        templateRenderer: TemplateRenderer
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.assetsProvider = assetsProvider
        self.colorStylesCoder = colorStylesCoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func saveColorStylesIfNeeded(_ colorStyles: [ColorStyle], in assets: String?) -> Promise<Void> {
        guard let assets = assets else {
            return .value(Void())
        }

        return assetsProvider.saveColorStyles(colorStyles, in: assets)
    }

    private func generate(parameters: GenerationParameters, assets: String?) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.nest { colorStyles in
            self.saveColorStylesIfNeeded(colorStyles, in: assets)
        }.done { colorStyles in
            let context = self.colorStylesCoder.encodeColorStyles(colorStyles)

            try self.templateRenderer.renderTemplate(
                parameters.template,
                to: parameters.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: ColorStylesConfiguration) -> Promise<Void> {
        return perform {
            try self.resolveGenerationParameters(from: configuration.generatation)
        }.then { parameters in
            self.generate(parameters: parameters, assets: configuration.assets)
        }
    }
}
