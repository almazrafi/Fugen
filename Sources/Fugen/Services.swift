import Foundation
import FugenTools

final class Services {

    // MARK: - Instance Methods

    func makeAPIService() -> FigmaAPIService {
        return HTTPService()
    }

    func makeAPIProvider(accessToken: String) -> FigmaAPIProvider {
        return DefaultFigmaAPIProvider(
            apiService: makeAPIService(),
            serverBaseURL: URL(string: "https://api.figma.com")!,
            accessToken: accessToken
        )
    }

    func makeNodesExtractor() -> NodesExtractor {
        return DefaultNodesExtractor()
    }
}
