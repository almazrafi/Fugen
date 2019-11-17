import Foundation
import FugenTools

final class Dependencies {

    // MARK: - Instance Methods

    func makeFigmaHTTPService() -> FigmaHTTPService {
        return HTTPService()
    }

    func makeFigmaAPIProvider() -> FigmaAPIProvider {
        return DefaultFigmaAPIProvider(httpService: makeFigmaHTTPService())
    }

    func makeFigmaNodesProvider() -> FigmaNodesProvider {
        return DefaultFigmaNodesProvider()
    }

    func makeConfigurationProvider() -> ConfigurationProvider {
        return DefaultConfigurationProvider()
    }

    func makeColorStylesProvider() -> ColorStylesProvider {
        return DefaultColorStylesProvider(
            apiProvider: makeFigmaAPIProvider(),
            nodesProvider: makeFigmaNodesProvider()
        )
    }

    func makeTextStylesProvider() -> TextStylesProvider {
        return DefaultTextStylesProvider(
            apiProvider: makeFigmaAPIProvider(),
            nodesProvider: makeFigmaNodesProvider()
        )
    }

    // MARK: -

    func makeColorCoder() -> ColorCoder {
        return DefaultColorCoder()
    }

    func makeFontCoder() -> FontCoder {
        return DefaultFontCoder()
    }

    func makeColorStylesCoder() -> ColorStylesCoder {
        return DefaultColorStylesCoder(colorCoder: makeColorCoder())
    }

    func makeTextStylesCoder() -> TextStylesCoder {
        return DefaultTextStylesCoder(
            fontCoder: makeFontCoder(),
            colorCoder: makeColorCoder()
        )
    }

    // MARK: -

    func makeStencilExtensions() -> [StencilExtension] {
        return [
            StencilNumberExtension(),
            StencilColorExtension(colorCoder: makeColorCoder()),
            StencilFontExtension(fontCoder: makeFontCoder())
        ]
    }

    func makeTemplateRenderer() -> TemplateRenderer {
        return DefaultTemplateRenderer(stencilExtensions: makeStencilExtensions())
    }

    // MARK: -

    func makeColorStylesGenerator() -> ColorStylesGenerator {
        return DefaultColorStylesGenerator(
            colorStylesProvider: makeColorStylesProvider(),
            colorStylesCoder: makeColorStylesCoder(),
            templateRenderer: makeTemplateRenderer()
        )
    }

    func makeTextStylesGenerator() -> TextStylesGenerator {
        return DefaultTextStylesGenerator(
            textStylesProvider: makeTextStylesProvider(),
            textStylesCoder: makeTextStylesCoder(),
            templateRenderer: makeTemplateRenderer()
        )
    }

    func makeKitGenerator() -> KitGenerator {
        return DefaultKitGenerator(
            configurationProvider: makeConfigurationProvider(),
            colorStylesGenerator: makeColorStylesGenerator(),
            textStylesGenerator: makeTextStylesGenerator()
        )
    }
}
