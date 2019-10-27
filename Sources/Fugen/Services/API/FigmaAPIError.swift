import Foundation

struct FigmaAPIError: Error, Codable, CustomStringConvertible {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case status
        case message = "err"
    }

    // MARK: - Instance Properties

    let status: Int
    let message: String

    // MARK: - CustomStringConvertible

    var description: String {
        "\(String(describing: type(of: self))).\(status)(\(message))"
    }
}
