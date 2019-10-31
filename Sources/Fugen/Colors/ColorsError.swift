import Foundation

enum ColorsError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case styleNotFound(nodeID: String)
    case invalidStyleName(nodeID: String)
    case inappropriateStyle(styleName: String, nodeID: String)
    case colorNotFound(styleName: String, nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .styleNotFound(nodeID: nodeID):
            return "Figma file does not contain a style for node '\(nodeID)'"

        case let .invalidStyleName(nodeID: nodeID):
            return "Style name is either empty or nil in node '\(nodeID)'"

        case let .inappropriateStyle(styleName: styleName, nodeID: nodeID):
            return "Style '\(styleName)' has an ambiguous color in node '\(nodeID)'"

        case let .colorNotFound(styleName: styleName, nodeID: nodeID):
            return "Failed to extract a color of style '\(styleName)' in node '\(nodeID)'"
        }
    }
}
