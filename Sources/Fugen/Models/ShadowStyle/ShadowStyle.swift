import Foundation
import FugenTools

struct ShadowStyle: Encodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case name
        case description
        case shadows
    }

    // MARK: - Instance Properties

    let name: String
    let description: String?
    let nodes: [ShadowStyleNode]

    // MARK: - Encodable

    func encode(to encoder: Encoder) throws {
        try name.encode(to: encoder, forKey: CodingKeys.name)
        try description.encode(to: encoder, forKey: CodingKeys.description)
        try nodes.encode(to: encoder, forKey: CodingKeys.shadows)
    }
}
