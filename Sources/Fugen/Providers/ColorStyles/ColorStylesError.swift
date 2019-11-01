import Foundation

enum ColorStylesError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case styleNotFound(nodeName: String, nodeID: String)
    case invalidStyleName(nodeName: String, nodeID: String)
    case colorNotFound(nodeName: String, nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .styleNotFound(nodeName, nodeID):
            return "Figma file does not contain a valid color style for node \(nodeName) ('\(nodeID)')"

        case let .invalidStyleName(nodeName, nodeID):
            return "Style name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case let .colorNotFound(nodeName, nodeID):
            return "Style color of node \(nodeName) ('\(nodeID)') could not be found"
        }
    }
}
