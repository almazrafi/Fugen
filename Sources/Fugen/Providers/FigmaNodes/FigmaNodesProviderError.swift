import Foundation

enum FigmaNodesProviderError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidNodeID(_ nodeID: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidNodeID(nodeID):
            return "Figma node ID '\(nodeID)' is invalid and cannot be used to exclude or include"
        }
    }
}
