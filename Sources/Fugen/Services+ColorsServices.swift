import Foundation

extension Services: ColorsServices {

    // MARK: - Instance Methods

    func makeColorsProvider(accessToken: String) -> ColorsProvider {
        return DefaultColorsProvider(
            apiProvider: makeAPIProvider(accessToken: accessToken),
            nodesExtractor: makeNodesExtractor()
        )
    }
}
