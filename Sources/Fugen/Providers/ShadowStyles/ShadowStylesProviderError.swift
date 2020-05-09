import Foundation

struct ShadowStylesProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case styleNotFound
        case invalidStyleName

        case shadowEffectsNotFound
        case colorNotFound
        case offsetNotFound
    }

    // MARK: - Instance Properties

    let code: Code
    let nodeID: String
    let nodeName: String?

    var nodeInfo: String {
        let nodeName = self.nodeName ?? "nil"

        return "\(nodeName) ('\(nodeID)')"
    }

    // MARK: - CustomStringConvertible

    var description: String {
        switch code {
        case .styleNotFound:
            return "Figma file does not contain a valid style for node \(nodeInfo)"

        case .invalidStyleName:
            return "Style name of node \(nodeInfo) is either empty or nil"

        case .shadowEffectsNotFound:
            return "Figma file does not contain any shadow effects for node \(nodeInfo)"

        case .colorNotFound:
            return "Shadow color of node \(nodeInfo) could not be found"

        case .offsetNotFound:
            return "Shadow offset of node \(nodeInfo) could not be found"
        }
    }
}
