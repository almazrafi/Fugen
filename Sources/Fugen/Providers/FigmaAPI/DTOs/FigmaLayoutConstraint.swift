import Foundation

struct FigmaLayoutConstraint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawVertical = "vertical"
        case rawHorizontal = "horizontal"
    }

    // MARK: - Instance Properties

    let rawVertical: String?
    let rawHorizontal: String?

    var vertical: FigmaLayoutVerticalConstraint? {
        rawVertical.flatMap(FigmaLayoutVerticalConstraint.init)
    }

    var horizontal: FigmaLayoutHorizontalConstraint? {
        rawHorizontal.flatMap(FigmaLayoutHorizontalConstraint.init)
    }
}
