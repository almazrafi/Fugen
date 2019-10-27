import Foundation

public final class HTTPJSONResponseSerializer: HTTPResponseSerializer {

    // MARK: - Instance Properties

    public let options: JSONSerialization.ReadingOptions

    // MARK: - HTTPResponseSerializer

    public let emptyResponseStatusCodes: Set<HTTPStatusCode>
    public let emptyResponseMethods: Set<HTTPMethod>

    // MARK: - Initializers

    public init(
        options: JSONSerialization.ReadingOptions,
        emptyResponseStatusCodes: Set<HTTPStatusCode> = defaultEmptyResponseStatusCodes,
        emptyResponseMethods: Set<HTTPMethod> = defaultEmptyResponseMethods
    ) {
        self.options = options
        self.emptyResponseStatusCodes = emptyResponseStatusCodes
        self.emptyResponseMethods = emptyResponseMethods
    }

    // MARK: - Instance Methods

    public func serialize(data: Data, statusCode: HTTPStatusCode, method: HTTPMethod) throws -> Any {
        return try JSONSerialization.jsonObject(with: data, options: options)
    }
}
