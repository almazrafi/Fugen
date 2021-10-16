import Foundation

struct GradientStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let description: String?
    let gradientType: GradientType
    let gradientStops: [ColorStop]
}
