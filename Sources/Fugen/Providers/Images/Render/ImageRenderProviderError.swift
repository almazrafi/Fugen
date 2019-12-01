import Foundation

struct ImageRenderProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case invalidImage
        case invalidImageURL
    }

    // MARK: - Instance Properties

    let code: Code
    let nodeID: String
    let nodeName: String?

    // MARK: - CustomStringConvertible

    var description: String {
        let nodeName = self.nodeName ?? "nil"

        switch code {
        case .invalidImage:
            return "Image for node \(nodeName) ('\(nodeID)') cannot be rendered"

        case .invalidImageURL:
            return "Image for node \(nodeName) ('\(nodeID)') was rendered with an invalid URL"
        }
    }
}
