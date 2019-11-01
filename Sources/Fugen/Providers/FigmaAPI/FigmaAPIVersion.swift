import Foundation

enum FigmaAPIVersion {

    // MARK: - Enumeration Cases

    case v1

    // MARK: - Instance Properties

    var urlPath: String {
        switch self {
        case .v1:
            return "v1"
        }
    }
}
