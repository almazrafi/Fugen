import Foundation

struct FigmaRectangleNodePayload: Decodable, Hashable {

    // MARK: - Instance Properties

    let cornerRadius: Double?
    let rectangleCornerRadii: [Double]?
}
