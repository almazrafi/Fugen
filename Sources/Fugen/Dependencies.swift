import Foundation
import FugenTools

final class Dependencies {

    // MARK: - Instance Methods

    func makeHTTPService() -> FigmaHTTPService {
        return HTTPService()
    }

    func makeAPIProvider() -> FigmaAPIProvider {
        return DefaultFigmaAPIProvider(httpService: makeHTTPService())
    }

    func makeNodesExtractor() -> NodesExtractor {
        return DefaultNodesExtractor()
    }

    func makeTemplateRenderer() -> TemplateRenderer {
        return DefaultTemplateRenderer()
    }
}

extension Dependencies: ColorsDependencies {

    // MARK: - Instance Methods

    func makeColorsProvider() -> ColorsProvider {
        return DefaultColorsProvider(
            apiProvider: makeAPIProvider(),
            nodesExtractor: makeNodesExtractor()
        )
    }

    func makeColorsRenderer() -> ColorsRenderer {
        return DefaultColorsRenderer(templateRenderer: makeTemplateRenderer())
    }
}
