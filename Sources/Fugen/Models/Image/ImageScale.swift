import Foundation

enum ImageScale {

    // MARK: - Enumeration Cases

    case single
    case scale1x
    case scale2x
    case scale3x

    // MARK: - Instance Properties

    var fileNameSuffix: String {
        switch self {
        case .single, .scale1x:
            return ""

        case .scale2x:
            return "@2x"

        case .scale3x:
            return "@3x"
        }
    }
}
