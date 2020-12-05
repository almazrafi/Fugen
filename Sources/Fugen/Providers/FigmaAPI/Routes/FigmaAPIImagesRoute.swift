import Foundation

struct FigmaAPIImagesRoute: FigmaAPIRoute {

    // MARK: - Nested Types

    typealias Response = FigmaImages
    typealias QueryParameters = FigmaAPIImagesRouteQueryParameters

    // MARK: - Instance Properties

    let accessToken: String?
    let fileKey: String

    let queryParameters: QueryParameters?

    var urlPath: String {
        "images/\(fileKey)"
    }

    // MARK: - Initializers

    init(
        accessToken: String,
        fileKey: String,
        fileVersion: String? = nil,
        nodeIDs: [String],
        format: FigmaImageFormat? = nil,
        scale: Double? = nil,
        svgIncludeID: Bool? = nil,
        svgSimplifyStroke: Bool? = nil,
        useAbsoluteBounds: Bool? = nil
    ) {
        self.accessToken = accessToken
        self.fileKey = fileKey

        self.queryParameters = QueryParameters(
            fileVersion: fileVersion,
            nodeIDs: nodeIDs.joined(separator: .nodeIDsSeparator),
            format: format?.rawValue.lowercased(),
            scale: scale,
            svgIncludeID: svgIncludeID,
            svgSimplifyStroke: svgSimplifyStroke,
            useAbsolutBounds: useAbsoluteBounds
        )
    }
}

private extension String {

    // MARK: - Type Properties

    static let nodeIDsSeparator = ","
}
