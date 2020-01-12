import Foundation

public struct HTTPResponse<T>: CustomStringConvertible {

    // MARK: - Instance Properties

    public let result: Result<T, HTTPError>
    public let statusCode: HTTPStatusCode?
    public let headers: [HTTPHeader]?

    // MARK: -

    public var value: T? {
        switch result {
        case let .success(value):
            return value

        case .failure:
            return nil
        }
    }

    public var error: HTTPError? {
        switch result {
        case .success:
            return nil

        case let .failure(error):
            return error
        }
    }

    public var isSuccess: Bool {
        switch result {
        case .success:
            return true

        case .failure:
            return false
        }
    }

    public var isFailure: Bool {
        !isSuccess
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        switch result {
        case .success:
            return "\(type(of: self)).success"

        case let .failure(error):
            return "\(type(of: self)).failure(\(error))"
        }
    }

    // MARK: - Initializers

    public init(
        _ result: Result<T, HTTPError>,
        statusCode: HTTPStatusCode? = nil,
        headers: [HTTPHeader]? = nil
    ) {
        self.result = result
        self.statusCode = statusCode
        self.headers = headers
    }
}
