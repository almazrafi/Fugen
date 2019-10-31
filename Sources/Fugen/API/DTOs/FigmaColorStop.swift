import Foundation

struct FigmaColorStop: Decodable, Hashable {

    // MARK: - Instance Properties

    let position: Double
    let color: FigmaColor
}
