import Foundation

public protocol HTTPTask: AnyObject {

    // MARK: - Instance Properties

    var route: HTTPRoute { get }
    var response: HTTPResponse<Data?>? { get }

    var isFinished: Bool { get }

    // MARK: - Instance Methods

    @discardableResult
    func response(
        on queue: DispatchQueue,
        completion: @escaping (_ response: HTTPResponse<Data?>) -> Void
    ) -> Self

    @discardableResult
    func response<Serializer: HTTPResponseSerializer>(
        on queue: DispatchQueue,
        serializer: Serializer,
        completion: @escaping (_ response: HTTPResponse<Serializer.SerializedObject>) -> Void
    ) -> Self

    @discardableResult
    func responseData(
        on queue: DispatchQueue,
        completion: @escaping (_ response: HTTPResponse<Data>) -> Void
    ) -> Self

    @discardableResult
    func responseString(
        on queue: DispatchQueue,
        encoding: String.Encoding,
        completion: @escaping (_ response: HTTPResponse<String>) -> Void
    ) -> Self

    @discardableResult
    func responseJSON(
        on queue: DispatchQueue,
        options: JSONSerialization.ReadingOptions,
        completion: @escaping (_ response: HTTPResponse<Any>) -> Void
    ) -> Self

    @discardableResult
    func responseDecodable<T: Decodable>(
        type: T.Type,
        on queue: DispatchQueue,
        decoder: HTTPResponseDecoder,
        completion: @escaping (_ response: HTTPResponse<T>) -> Void
    ) -> Self

    func cancel()
}

extension HTTPTask {

    // MARK: - Instance Properties

    public var isFinished: Bool {
        response != nil
    }

    // MARK: - Instance Methods

    @discardableResult
    public func response(completion: @escaping (_ response: HTTPResponse<Data?>) -> Void) -> Self {
        return response(on: .main, completion: completion)
    }

    @discardableResult
    public func response<Serializer: HTTPResponseSerializer>(
        serializer: Serializer,
        completion: @escaping (_ response: HTTPResponse<Serializer.SerializedObject>) -> Void
    ) -> Self {
        return response(on: .main, serializer: serializer, completion: completion)
    }

    @discardableResult
    public func responseData(completion: @escaping (_ response: HTTPResponse<Data>) -> Void) -> Self {
        return responseData(on: .main, completion: completion)
    }

    @discardableResult
    public func responseString(
        encoding: String.Encoding = .utf8,
        completion: @escaping (_ response: HTTPResponse<String>) -> Void
    ) -> Self {
        return responseString(on: .main, encoding: encoding, completion: completion)
    }

    @discardableResult
    public func responseJSON(
        options: JSONSerialization.ReadingOptions = .allowFragments,
        completion: @escaping (_ response: HTTPResponse<Any>) -> Void
    ) -> Self {
        return responseJSON(on: .main, options: options, completion: completion)
    }

    @discardableResult
    public func responseDecodable<T: Decodable>(
        type: T.Type,
        decoder: HTTPResponseDecoder = JSONDecoder(),
        completion: @escaping (_ response: HTTPResponse<T>) -> Void
    ) -> Self {
        return responseDecodable(type: type, on: .main, decoder: decoder, completion: completion)
    }
}
