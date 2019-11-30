import Foundation
import FugenTools
import PromiseKit

final class DefaultImagesGenerator: ImagesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let imagesProvider: ImagesProvider
    let assetsProvider: AssetsProvider
//    let imagesCoder: ImagesCoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "Images")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        imagesProvider: ImagesProvider,
        assetsProvider: AssetsProvider,
//        imagesCoder: ImagesCoder,
        templateRenderer: TemplateRenderer
    ) {
        self.imagesProvider = imagesProvider
        self.assetsProvider = assetsProvider
//        self.imagesCoder = imagesCoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func saveImagesIfNeeded(_ images: [Image], in assets: String?) -> Promise<Void> {
        guard let assets = assets else {
            return .value(Void())
        }

        return assetsProvider.saveImages(images, in: assets)
    }

    private func generate(
        parameters: GenerationParameters,
        assets: String?,
        resources: String?,
        format: ImageFormat,
        scales: [ImageScale]
    ) -> Promise<Void> {
        return firstly {
            self.imagesProvider.fetchImages(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                format: format,
                scales: scales,
                accessToken: parameters.accessToken
            )
        }.nest { images in
            self.saveImagesIfNeeded(images, in: assets)
        }.done { images in
//            let context = self.colorStylesCoder.encodeColorStyles(colorStyles)
//
//            try self.templateRenderer.renderTemplate(
//                parameters.template,
//                to: parameters.destination,
//                context: context
//            )
        }
    }

    // MARK: -

    func generate(configuration: ImagesConfiguration) -> Promise<Void> {
        return perform {
            try self.resolveGenerationParameters(from: configuration.generatation)
        }.then { parameters in
            self.generate(
                parameters: parameters,
                assets: configuration.assets,
                resources: configuration.resources,
                format: configuration.format,
                scales: configuration.scales
            )
        }
    }
}
