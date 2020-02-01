import Foundation

enum ImageScale: String, Codable {

    // MARK: - Enumeration Cases

    case none = "none"
    case scale1x = "1"
    case scale2x = "2"
    case scale3x = "3"

    // MARK: - Instance Properties

    var fileNameSuffix: String {
        switch self {
        case .none, .scale1x:
            return ""

        case .scale2x:
            return "@2x"

        case .scale3x:
            return "@3x"
        }
    }
}
