import Foundation

public final class HTTPStringResponseSerializer: HTTPResponseSerializer {

    // MARK: - Instance Properties

    public let encoding: String.Encoding

    // MARK: - HTTPResponseSerializer

    public let emptyResponseStatusCodes: Set<HTTPStatusCode>
    public let emptyResponseMethods: Set<HTTPMethod>

    // MARK: - Initializers

    public init(
        encoding: String.Encoding,
        emptyResponseStatusCodes: Set<HTTPStatusCode> = defaultEmptyResponseStatusCodes,
        emptyResponseMethods: Set<HTTPMethod> = defaultEmptyResponseMethods
    ) {
        self.encoding = encoding
        self.emptyResponseStatusCodes = emptyResponseStatusCodes
        self.emptyResponseMethods = emptyResponseMethods
    }

    // MARK: - Instance Methods

    public func serialize(data: Data, statusCode: HTTPStatusCode, method: HTTPMethod) throws -> String {
        guard let string = String(data: data, encoding: encoding) else {
            throw MessageError("String serialization failed with encoding: \(encoding)")
        }

        return string
    }
}

extension String: HTTPEmptyResponse {

    // MARK: - Type Methods

    public static func emptyResponseInstance() -> String {
        return ""
    }
}
