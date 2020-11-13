import Foundation

struct ShadowStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let description: String?
    let shadows: [Shadow]
}
