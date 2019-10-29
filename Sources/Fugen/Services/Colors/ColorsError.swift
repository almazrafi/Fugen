import Foundation

enum ColorsError: Error, CustomStringConvertible {

    // MARK: - Enumeration Cases

    case invalidStyle(styleID: String)
    case stylesNotFound

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidStyle(styleID: styleID):
            return "Failed to extract the color for a style \(styleID)."

        case .stylesNotFound:
            return "Figma file does not contain any styles."
        }
    }
}
