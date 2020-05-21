import Foundation

struct ShadowStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let id: String
    let type: String
    let visible: Bool?
    let radius: Double
    let color: Color
    let blendMode: String?
    let offset: Vector
}
