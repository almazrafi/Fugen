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

    func makeColorEncoder() -> ColorEncoder {
        return DefaultColorEncoder()
    }

    func makeFontEncoder() -> FontEncoder {
        return DefaultFontEncoder()
    }

    func makeColorStylesEncoder() -> ColorStylesEncoder {
        return DefaultColorStylesEncoder(colorEncoder: makeColorEncoder())
    }

    func makeTextStylesEncoder() -> TextStylesEncoder {
        return DefaultTextStylesEncoder(
            fontEncoder: makeFontEncoder(),
            colorEncoder: makeColorEncoder()
        )
    }

    func makeTemplateRenderer() -> TemplateRenderer {
        return DefaultTemplateRenderer()
    }
}
