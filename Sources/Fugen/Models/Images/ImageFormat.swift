import Foundation

enum ImageFormat: String, Codable {

    // MARK: - Enumeration Cases

    case pdf
    case png
    case jpg
    case svg

    // MARK: - Instance Properties

    var fileExtension: String {
        rawValue
    }

    // MARK: - Instance Methods

    func assetName(for fileName: String) -> String {
        return fileName
    }

    func resourceName(for fileName: String) -> String {
        return "\(fileName).\(fileExtension)"
    }
}
