import Foundation

struct ShadowStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?
    let shadows: [Shadow]
}
