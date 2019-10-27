import Foundation

public struct MessageError: Error, CustomStringConvertible, Hashable {

    // MARK: - Instance Properties

    public let message: String

    public var localizedDescription: String {
        message
    }

    public var description: String {
        "\(String(describing: type(of: self)))(\"\(message)\")"
    }

    // MARK: - Initializers

    public init(_ message: String) {
        self.message = message
    }
}
