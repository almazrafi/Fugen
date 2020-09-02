import Foundation

struct ColorStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?
    let color: Color
}
