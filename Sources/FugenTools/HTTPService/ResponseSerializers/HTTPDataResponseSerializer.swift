import Foundation

public final class HTTPDataResponseSerializer: HTTPResponseSerializer {

    // MARK: - Instance Properties

    public let emptyResponseStatusCodes: Set<HTTPStatusCode>
    public let emptyResponseMethods: Set<HTTPMethod>

    // MARK: - Initializers

    public init(
        emptyResponseStatusCodes: Set<HTTPStatusCode> = defaultEmptyResponseStatusCodes,
        emptyResponseMethods: Set<HTTPMethod> = defaultEmptyResponseMethods
    ) {
        self.emptyResponseStatusCodes = emptyResponseStatusCodes
        self.emptyResponseMethods = emptyResponseMethods
    }

    // MARK: - Instance Methods

    public func serialize(data: Data, statusCode: HTTPStatusCode, method: HTTPMethod) throws -> Data {
        return data
    }
}

extension Data: HTTPEmptyResponse {

    // MARK: - Type Methods

    public static func emptyResponseInstance() -> Data {
        return Data()
    }
}
