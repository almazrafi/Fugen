import Foundation

struct ColorStyleNode: Encodable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?
    let opacity: Double?
    let color: Color
}

extension ColorStyleNode: Hashable {
    static func == (lhs: ColorStyleNode, rhs: ColorStyleNode) -> Bool {
        return lhs.name == rhs.name && lhs.color == rhs.color
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(color)
    }
}
