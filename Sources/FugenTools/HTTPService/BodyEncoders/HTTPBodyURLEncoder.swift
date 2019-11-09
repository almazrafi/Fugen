import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class HTTPBodyURLEncoder: HTTPBodyEncoder {

    // MARK: - Type Properties

    public static let `default` = HTTPBodyURLEncoder(urlEncoder: URLEncoder())

    // MARK: - Instance Properties

    public let urlEncoder: URLEncoder

    // MARK: - Initializers

    public init(urlEncoder: URLEncoder) {
        self.urlEncoder = urlEncoder
    }

    // MARK: - Instance Methods

    public func encode<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest {
        var request = request

        request.httpBody = try urlEncoder.encode(parameters)

        if !request.httpBody.isEmptyOrNil, request.value(forHTTPHeaderField: .contentTypeHeaderField) == nil {
            request.setValue(.contentTypeHeaderValue, forHTTPHeaderField: .contentTypeHeaderField)
        }

        return request
    }
}

private extension String {

    // MARK: - Type Properties

    static let contentTypeHeaderField = "Content-Type"
    static let contentTypeHeaderValue = "application/x-www-form-urlencoded; charset=utf-8"
}
