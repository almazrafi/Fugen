import Foundation

enum ImageFormat: Hashable {

    // MARK: - Enumeration Cases

    case pdf
    case png
    case jpg
    case svg

    // MARK: - Instance Properties

    var fileExtension: String {
        switch self {
        case .pdf:
            return "pdf"

        case .png:
            return "png"

        case .jpg:
            return "jpg"

        case .svg:
            return "svg"
        }
    }
}
