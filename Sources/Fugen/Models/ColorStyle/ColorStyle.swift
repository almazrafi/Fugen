import Foundation
import FugenTools

struct ColorStyle: Encodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case asset
    }

    // MARK: - Instance Properties

    let node: ColorStyleNode
    let asset: ColorStyleAsset?

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try node.encode(to: encoder)
        try asset?.encode(to: encoder, forKey: CodingKeys.asset)
    }
}
