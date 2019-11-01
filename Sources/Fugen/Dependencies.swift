import Foundation
import FugenTools

final class Dependencies {

    // MARK: - Instance Methods

    func makeHTTPService() -> FigmaHTTPService {
        return HTTPService()
    }

    func makeFigmaAPIProvider() -> FigmaAPIProvider {
        return DefaultFigmaAPIProvider(httpService: makeHTTPService())
    }

    func makeFigmaNodesProvider() -> FigmaNodesProvider {
        return DefaultFigmaNodesProvider()
    }

    func makeColorEncoder() -> ColorEncoder {
        return DefaultColorEncoder()
    }

    func makeFontEncoder() -> FontEncoder {
        return DefaultFontEncoder()
    }

    func makeTemplateRenderer() -> TemplateRenderer {
        return DefaultTemplateRenderer()
    }
}

extension Dependencies: ColorStylesDependencies {

    // MARK: - Instance Methods

    func makeColorStylesProvider() -> ColorStylesProvider {
        return DefaultColorStylesProvider(
            apiProvider: makeFigmaAPIProvider(),
            nodesProvider: makeFigmaNodesProvider()
        )
    }

    func makeColorStylesEncoder() -> ColorStylesEncoder {
        return DefaultColorStylesEncoder(colorEncoder: makeColorEncoder())
    }
}

extension Dependencies: TextStylesDependencies {

    // MARK: - Instance Methods

    func makeTextStylesProvider() -> TextStylesProvider {
        return DefaultTextStylesProvider(
            apiProvider: makeFigmaAPIProvider(),
            nodesProvider: makeFigmaNodesProvider()
        )
    }

    func makeTextStylesEncoder() -> TextStylesEncoder {
        return DefaultTextStylesEncoder(
            fontEncoder: makeFontEncoder(),
            colorEncoder: makeColorEncoder()
        )
    }
}
