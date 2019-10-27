import Foundation

struct FigmaColor: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case red = "r"
        case green = "g"
        case blue = "b"
        case alpha = "a"
    }

    // MARK: - Instance Properties

    let red: Double
    let green: Double
    let blue: Double
    let alpha: Double
}
