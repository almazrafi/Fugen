import Foundation

enum FigmaBooleanOperationType: String, Hashable {

    // MARK: - Enumeration Cases

    case union = "UNION"
    case intersect = "INTERSECT"
    case subtract = "SUBTRACT"
    case exclude = "EXCLUDE"
}
