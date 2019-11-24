import Foundation

struct TextStylesProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case styleNotFound
        case invalidStyleName
        case typeStyleNotFound

        case invalidFontFamily
        case invalidFontWeight
        case invalidFontSize

        case invalidColor
        case colorNotFound
        case colorStyleNotFound
        case invalidColorStyleName
    }

    // MARK: - Instance Properties

    let code: Code
    let nodeID: String
    let nodeName: String?

    // MARK: - CustomStringConvertible

    var description: String {
        let nodeName = self.nodeName ?? "nil"

        switch code {
        case .styleNotFound:
            return "Figma file does not contain a valid style for node \(nodeName) ('\(nodeID)')"

        case .invalidStyleName:
            return "Style name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case .typeStyleNotFound:
            return "Type style of node \(nodeName) ('\(nodeID)') could not be found"

        case .invalidFontFamily:
            return "Font family of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case .invalidFontWeight:
            return "Font weight of node \(nodeName) ('\(nodeID)') is nil"

        case .invalidFontSize:
            return "Font size of node \(nodeName) ('\(nodeID)') is nil"

        case .invalidColor:
            return "Color of node \(nodeName) ('\(nodeID)') cannot be resolved"

        case .colorNotFound:
            return "Color of node \(nodeName) ('\(nodeID)') could not be found"

        case .colorStyleNotFound:
            return "Figma file does not contain a valid color style for node \(nodeName) ('\(nodeID)')"

        case .invalidColorStyleName:
            return "Color style name of node \(nodeName) ('\(nodeID)') is either empty or nil"
        }
    }
}
