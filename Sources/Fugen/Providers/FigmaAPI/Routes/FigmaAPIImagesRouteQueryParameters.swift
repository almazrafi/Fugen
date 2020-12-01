import Foundation

struct FigmaAPIImagesRouteQueryParameters: Encodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case fileVersion = "version"
        case nodeIDs = "ids"
        case format
        case scale
        case svgIncludeID = "svg_include_id"
        case svgSimplifyStroke = "svg_simplify_stroke"
        case useAbsolutBounds = "use_absolute_bounds"
    }

    // MARK: - Instance Properties

    let fileVersion: String?
    let nodeIDs: String
    let format: String?
    let scale: Double?
    let svgIncludeID: Bool?
    let svgSimplifyStroke: Bool?
    let useAbsolutBounds: Bool?
}
