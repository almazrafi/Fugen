import Foundation

struct FigmaAPIFileRoute: FigmaAPIRoute {

    // MARK: - Nested Types

    typealias Response = FigmaFile
    typealias QueryParameters = FigmaAPIFileRouteQueryParameters

    // MARK: - Instance Properties

    let accessToken: String?
    let fileKey: String

    let queryParameters: QueryParameters?

    var urlPath: String {
        "files/\(fileKey)"
    }

    // MARK: - Initializers

    init(
        accessToken: String,
        fileKey: String,
        version: String? = nil,
        nodeIDs: [String]? = nil,
        depth: Int? = nil
    ) {
        self.accessToken = accessToken
        self.fileKey = fileKey

        self.queryParameters = QueryParameters(
            version: version,
            nodeIDs: nodeIDs?.joined(separator: .nodeIDsSeparator),
            depth: depth
        )
    }
}

private extension String {

    // MARK: - Type Properties

    static let nodeIDsSeparator = ","
}
