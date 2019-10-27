import Foundation

struct FigmaLayoutConstraint: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawVertical = "vertical"
        case rawHorizontal = "horizontal"
    }

    // MARK: - Instance Properties

    let rawVertical: String
    let rawHorizontal: String

    var vertical: FigmaLayoutVerticalConstraint? {
        FigmaLayoutVerticalConstraint(rawValue: rawVertical)
    }

    var horizontal: FigmaLayoutHorizontalConstraint? {
        FigmaLayoutHorizontalConstraint(rawValue: rawHorizontal)
    }
}
