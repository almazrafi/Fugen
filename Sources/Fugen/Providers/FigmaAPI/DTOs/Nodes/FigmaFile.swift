import Foundation

struct FigmaFile: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case name
        case lastModified
        case thumbnailURL = "thumbnailUrl"
        case version
        case schemaVersion
        case document
        case components
        case styles
    }

    // MARK: - Instance Properties

    let name: String
    let lastModified: Date?
    let thumbnailURL: URL?
    let version: String?
    let schemaVersion: Int?
    let document: FigmaNode
    let components: [String: FigmaComponent]?
    let styles: [String: FigmaStyle]?
}
