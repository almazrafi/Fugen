import Foundation
import FugenTools
import PromiseKit

final class DefaultImagesGenerator: ImagesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let imagesProvider: ImagesProvider
    let imagesCoder: ImagesCoder
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "Images")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        imagesProvider: ImagesProvider,
        imagesCoder: ImagesCoder,
        templateRenderer: TemplateRenderer
    ) {
        self.imagesProvider = imagesProvider
        self.imagesCoder = imagesCoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters, imagesParameters: ImagesParameters) -> Promise<Void> {
        return firstly {
            self.imagesProvider.fetchImages(
                from: parameters.file,
                nodes: parameters.nodes,
                parameters: imagesParameters
            )
        }.done { images in
            let context = self.imagesCoder.encodeImages(images)

            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: ImagesConfiguration) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration.generatation)
        }.then { parameters in
            self.generate(parameters: parameters, imagesParameters: configuration.imagesParameters)
        }
    }
}

private extension ImagesConfiguration {

    // MARK: - Instance Properties

    var imagesParameters: ImagesParameters {
        ImagesParameters(format: format, scales: scales, assets: assets, resources: resources)
    }
}
