import Foundation

public protocol HTTPResponseSerializer {

    // MARK: - Nested Types

    associatedtype SerializedObject

    // MARK: - Instance Properties

    var emptyResponseStatusCodes: Set<HTTPStatusCode> { get }
    var emptyResponseMethods: Set<HTTPMethod> { get }

    // MARK: - Instance Methods

    func serialize(data: Data, statusCode: HTTPStatusCode, method: HTTPMethod) throws -> SerializedObject
    func serializeEmptyResponse(statusCode: HTTPStatusCode, method: HTTPMethod) throws -> SerializedObject
}

extension HTTPResponseSerializer {

    // MARK: - Type Properties

    public static var defaultEmptyResponseStatusCodes: Set<HTTPStatusCode> {
        [204, 205]
    }

    public static var defaultEmptyResponseMethods: Set<HTTPMethod> {
        [.head]
    }

    // MARK: - Instance Methods

    public func serializeEmptyResponse(statusCode: HTTPStatusCode, method: HTTPMethod) throws -> SerializedObject {
        guard emptyResponseStatusCodes.contains(statusCode) || emptyResponseMethods.contains(method) else {
            throw MessageError("Empty response is unacceptable")
        }

        guard let emptyResponseType = SerializedObject.self as? HTTPEmptyResponse.Type else {
            throw MessageError("\(SerializedObject.self) cannot have an empty instance")
        }

        guard let emptyResponseInstance = emptyResponseType.emptyResponseInstance() as? SerializedObject else {
            throw MessageError("Empty instance of \(SerializedObject.self) has an invalid type")
        }

        return emptyResponseInstance
    }
}
