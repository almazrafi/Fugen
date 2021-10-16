import Foundation

struct GradientStyle: Encodable, Hashable {

    // MARK: - Instance Properties

    let node: GradientStyleNode

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try node.encode(to: encoder)
    }
}
