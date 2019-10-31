import Foundation

struct FigmaStyle: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case key
        case rawType = "styleType"
        case name
        case description
    }

    // MARK: - Instance Properties

    let key: String?
    let rawType: String?
    let name: String?
    let description: String?

    var type: FigmaStyleType? {
        rawType.flatMap(FigmaStyleType.init)
    }
}
