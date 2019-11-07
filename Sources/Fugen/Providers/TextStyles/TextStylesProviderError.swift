import Foundation

enum TextStylesProviderError: Error {

    // MARK: - Enumeration Cases

    case styleNotFound(nodeName: String, nodeID: String)
    case invalidStyleName(nodeName: String, nodeID: String)
    case typeStyleNotFound(nodeName: String, nodeID: String)

    case invalidFontFamily(nodeName: String, nodeID: String)
    case invalidFontPostScriptName(nodeName: String, nodeID: String)
    case invalidFontWeight(nodeName: String, nodeID: String)
    case invalidFontSize(nodeName: String, nodeID: String)

    case invalidTextColor(nodeName: String, nodeID: String)
    case textColorNotFound(nodeName: String, nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .styleNotFound(nodeName, nodeID):
            return "Figma file does not contain a valid style for node \(nodeName) ('\(nodeID)')"

        case let .invalidStyleName(nodeName, nodeID):
            return "Style name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case let .typeStyleNotFound(nodeName, nodeID):
            return "Type style of node \(nodeName) ('\(nodeID)') could not be found"

        case let .invalidFontFamily(nodeName, nodeID):
            return "Font family of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case let .invalidFontPostScriptName(nodeName, nodeID):
            return "PostScript font name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case let .invalidFontWeight(nodeName, nodeID):
            return "Font weight of node \(nodeName) ('\(nodeID)') is nil"

        case let .invalidFontSize(nodeName, nodeID):
            return "Font size of node \(nodeName) ('\(nodeID)') is nil"

        case let .invalidTextColor(nodeName, nodeID):
            return "Text color of node \(nodeName) ('\(nodeID)') cannot be resolved"

        case let .textColorNotFound(nodeName, nodeID):
            return "Text color of node \(nodeName) ('\(nodeID)') could not be found"
        }
    }
}
