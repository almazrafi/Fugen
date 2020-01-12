import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct HTTPRoute: CustomStringConvertible {

    // MARK: - Instance Properties

    public let method: HTTPMethod
    public let url: URL
    public let headers: [HTTPHeader]

    public let queryParameters: Encodable?
    public let queryEncoder: HTTPQueryEncoder

    public let bodyParameters: Encodable?
    public let bodyEncoder: HTTPBodyEncoder

    // MARK: - CustomStringConvertible

    public var description: String {
        "\(type(of: self)).\(method)(\(url.absoluteString))"
    }

    // MARK: - Initializers

    public init(
        method: HTTPMethod,
        url: URL,
        headers: [HTTPHeader] = [],
        queryParameters: Encodable? = nil,
        queryEncoder: HTTPQueryEncoder = HTTPQueryURLEncoder.default,
        bodyParameters: Encodable? = nil,
        bodyEncoder: HTTPBodyEncoder = HTTPBodyJSONEncoder.default
    ) {
        self.method = method
        self.url = url
        self.headers = headers

        self.queryParameters = queryParameters
        self.queryEncoder = queryEncoder

        self.bodyParameters = bodyParameters
        self.bodyEncoder = bodyEncoder
    }

    // MARK: - Instance Methods

    public func asRequest() throws -> URLRequest {
        var request: URLRequest

        if let queryParameters = queryParameters {
            let encodedURL = try queryEncoder.encode(
                url: url,
                parameters: HTTPAnyEncodable(queryParameters)
            )

            request = URLRequest(url: encodedURL)
        } else {
            request = URLRequest(url: url)
        }

        request.httpMethod = method.rawValue

        for header in headers {
            request.setValue(header.value, forHTTPHeaderField: header.name)
        }

        if let bodyParameters = bodyParameters {
            request = try bodyEncoder.encode(
                request: request,
                parameters: HTTPAnyEncodable(bodyParameters)
            )
        }

        return request
    }
}
