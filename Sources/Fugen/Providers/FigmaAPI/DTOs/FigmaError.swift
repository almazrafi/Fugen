import Foundation

struct FigmaError: Error, Decodable, Hashable, CustomStringConvertible {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case status
        case content = "err"
    }

    // MARK: - Instance Properties

    let status: Int
    let content: String

    // MARK: - CustomStringConvertible

    var description: String {
        "\(type(of: self)).\(status)(\(content))"
    }
}
