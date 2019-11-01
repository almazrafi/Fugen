import Foundation

struct FigmaTextNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case text = "characters"
        case style
        case characterStyleOverrides
        case styleOverrideTable
    }

    // MARK: - Instance Properties

    let text: String?
    let style: FigmaTypeStyle?
    let characterStyleOverrides: [Int]?
    let styleOverrideTable: [Int: FigmaTypeStyle]?
}
