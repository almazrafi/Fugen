import Foundation

public struct HTTPStatusCode: HTTPErrorStringConvertible, Hashable, ExpressibleByIntegerLiteral {

    // MARK: - Nested Types

    public enum State {

        // MARK: - Enumeration Cases

        case unknown
        case information
        case success
        case redirection
        case failure
    }

    // MARK: - Instance Properties

    public let rawValue: Int

    public var state: State {
        switch rawValue {
        case 100...199:
            return .information

        case 200...299:
            return .success

        case 300...399:
            return .redirection

        case 400...599:
            return .failure

        default:
            return .unknown
        }
    }

    // MARK: - HTTPErrorStringConvertible

    public var httpErrorDescription: String {
        "\(type(of: self)).\(rawValue)"
    }

    // MARK: - Initializers

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public init(integerLiteral: Int) {
        self.init(rawValue: integerLiteral)
    }
}
