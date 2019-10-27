import Foundation

struct FigmaAPIFileRoute: FigmaAPIRoute {

    // MARK: - Nested Types

    typealias Response = FigmaFile

    struct QueryParameters: Encodable {
        let version: String?
        let ids: String?
        let depth: Int?
    }

    // MARK: - Instance Properties

    let fileKey: String
    let queryParameters: QueryParameters?

    var urlPath: String {
        "files/\(fileKey)"
    }

    // MARK: - Initializers

    init(fileKey: String, version: String? = nil, ids: [String]? = nil, depth: Int? = nil) {
        self.fileKey = fileKey

        self.queryParameters = QueryParameters(
            version: version,
            ids: ids?.joined(separator: ", "),
            depth: depth
        )
    }
}
