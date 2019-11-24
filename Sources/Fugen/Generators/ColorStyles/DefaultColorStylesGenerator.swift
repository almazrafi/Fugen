import Foundation
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

    private func generate(parameters: GenerationParameters, assetsFolderPath: String?) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.done { colorStyles in
            if let assetsFolderPath = assetsFolderPath {
                try self.assetsProvider.saveColorStyles(colorStyles, in: assetsFolderPath)
            }

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
        return firstly {
            self.generate(
                parameters: try self.resolveGenerationParameters(from: configuration.generatation),
                assetsFolderPath: configuration.assetsFolderPath
            )
        }
    }
}
