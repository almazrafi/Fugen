import Foundation

struct FigmaAPIFileRouteQueryParameters: Encodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case version
        case nodeIDs = "ids"
        case depth
    }

    // MARK: - Instance Properties

    let version: String?
    let nodeIDs: String?
    let depth: Int?
}
