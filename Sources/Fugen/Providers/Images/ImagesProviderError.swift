import Foundation

struct ImagesProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case componentNotFound
        case invalidComponentName
    }

    // MARK: - Instance Properties

    let code: Code
    let nodeID: String
    let nodeName: String?

    // MARK: - CustomStringConvertible

    var description: String {
        let nodeName = self.nodeName ?? "nil"

        switch code {
        case .componentNotFound:
            return "Figma file does not contain a valid component for node \(nodeName) ('\(nodeID)')"

        case .invalidComponentName:
            return "Component name of node \(nodeName) ('\(nodeID)') is either empty or nil"
        }
    }
}
