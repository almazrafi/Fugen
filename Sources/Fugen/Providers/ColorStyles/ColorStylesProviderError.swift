import Foundation

struct ColorStylesProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case styleNotFound
        case invalidStyleName
        case colorNotFound
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
            return "Figma file does not contain a valid color style for node \(nodeName) ('\(nodeID)')"

        case .invalidStyleName:
            return "Style name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case .colorNotFound:
            return "Style color of node \(nodeName) ('\(nodeID)') could not be found"
        }
    }
}
