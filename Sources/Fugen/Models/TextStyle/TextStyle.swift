import Foundation
import FugenTools

struct TextStyle: Encodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case color
    }

    // MARK: - Instance Properties

    let node: TextStyleNode
    let color: TextStyleColor

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try node.encode(to: encoder)
        try color.encode(to: encoder, forKey: CodingKeys.color)
    }
}
