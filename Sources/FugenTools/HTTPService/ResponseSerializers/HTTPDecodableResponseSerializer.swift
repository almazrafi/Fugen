import Foundation

public final class HTTPDecodableResponseSerializer<T: Decodable>: HTTPResponseSerializer {

    // MARK: - Instance Properties

    public let decoder: HTTPResponseDecoder

    // MARK: - HTTPResponseSerializer

    public let emptyResponseStatusCodes: Set<HTTPStatusCode>
    public let emptyResponseMethods: Set<HTTPMethod>

    // MARK: - Initializers

    public init(
        decoder: HTTPResponseDecoder,
        emptyResponseStatusCodes: Set<HTTPStatusCode> = defaultEmptyResponseStatusCodes,
        emptyResponseMethods: Set<HTTPMethod> = defaultEmptyResponseMethods
    ) {
        self.decoder = decoder

        self.emptyResponseStatusCodes = emptyResponseStatusCodes
        self.emptyResponseMethods = emptyResponseMethods
    }

    // MARK: - Instance Methods

    public func serialize(data: Data, statusCode: HTTPStatusCode, method: HTTPMethod) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}
