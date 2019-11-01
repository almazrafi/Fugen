import Foundation

struct FigmaConstraint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case value
    }

    // MARK: - Instance Properties

    let rawType: String
    let value: Double

    var type: FigmaConstraintType? {
        FigmaConstraintType(rawValue: rawType)
    }
}
