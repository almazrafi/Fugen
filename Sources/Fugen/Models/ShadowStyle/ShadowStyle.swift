import Foundation
import FugenTools

struct ShadowStyle: Encodable, Hashable {

    // MARK: - Instance Properties

    let node: ShadowStyleNode

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try node.encode(to: encoder)
    }
}
