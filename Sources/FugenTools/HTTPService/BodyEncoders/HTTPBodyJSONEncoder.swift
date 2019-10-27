import Foundation

public final class HTTPBodyJSONEncoder: HTTPBodyEncoder {

    // MARK: - Type Properties

    public static let `default` = HTTPBodyJSONEncoder(jsonEncoder: JSONEncoder())

    // MARK: - Instance Properties

    public let jsonEncoder: JSONEncoder

    // MARK: - Initializers

    public init(jsonEncoder: JSONEncoder) {
        self.jsonEncoder = jsonEncoder
    }

    // MARK: - Instance Methods

    public func encode<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest {
        var request = request

        request.httpBody = try jsonEncoder.encode(parameters)

        if !request.httpBody.isEmptyOrNil, request.value(forHTTPHeaderField: Constants.contentTypeHeaderField) == nil {
            request.setValue(Constants.contentTypeHeaderValue, forHTTPHeaderField: Constants.contentTypeHeaderField)
        }

        return request
    }
}

private enum Constants {

    // MARK: - Type Properties

    static let contentTypeHeaderField = "Content-Type"
    static let contentTypeHeaderValue = "application/json"
}
