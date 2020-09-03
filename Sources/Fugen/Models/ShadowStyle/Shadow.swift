import Foundation

struct Shadow: Encodable, Hashable {

    // MARK: - Instance Properties

    let type: ShadowType
    let offset: Vector
    let radius: Double
    let color: Color
    let blendMode: String?
}
