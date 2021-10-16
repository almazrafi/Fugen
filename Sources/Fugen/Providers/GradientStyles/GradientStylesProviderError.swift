import Foundation

struct GradientStylesProviderError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case styleNotFound
        case invalidStyleName
        case gradientTypeNotFound
        case gradientStopsNotFound
    }

    // MARK: - Instance Properties

    let code: Code
    let nodeID: String
    let nodeName: String?

    // MARK: - CustomStringConvertible

    var description: String {
        let nodeName = nodeName ?? "nil"

        switch code {
        case .styleNotFound:
            return "Figma file does not contain a valid gradient style for node \(nodeName) ('\(nodeID)')"

        case .invalidStyleName:
            return "Style name of node \(nodeName) ('\(nodeID)') is either empty or nil"

        case .gradientTypeNotFound:
            return "Gradient type of node \(nodeName) ('\(nodeID)') could not be found"

        case .gradientStopsNotFound:
            return "Gradient stop points of node \(nodeName) ('\(nodeID)') could not be found"
        }
    }
}
