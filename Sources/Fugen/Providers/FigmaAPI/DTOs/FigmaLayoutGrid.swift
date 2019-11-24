import Foundation

struct FigmaLayoutGrid: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawPattern = "pattern"
        case rawAlignment = "alignment"
        case sectionSize
        case isVisible = "visible"
        case color
        case gutterSize
        case offset
        case count
    }

    // MARK: - Instance Properties

    let rawPattern: String?
    let rawAlignment: String?
    let sectionSize: Double?
    let isVisible: Bool?
    let color: FigmaColor?
    let gutterSize: Double?
    let offset: Double?
    let count: Double?

    var pattern: FigmaLayoutGridPattern? {
        rawPattern.flatMap(FigmaLayoutGridPattern.init)
    }

    var alignment: FigmaLayoutGridAlignment? {
        rawAlignment.flatMap(FigmaLayoutGridAlignment.init)
    }
}
