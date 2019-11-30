import Foundation

enum ImageFormat {

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

    // MARK: - Instance Methods

    func assetName(for fileName: String) -> String {
        return fileName
    }

    func resourceName(for fileName: String) -> String {
        return "\(fileName).\(fileExtension)"
    }
}
