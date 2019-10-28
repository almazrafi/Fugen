import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class HTTPServiceTask<SessionTask: URLSessionTask> {

    // MARK: - Instance Properties

    private var responseQueue: OperationQueue

    // MARK: -

    internal var sessionTask: SessionTask?
    internal let session: URLSession

    // MARK: -

    public let route: HTTPRoute

    public private(set) var response: HTTPResponse<Data?>?

    // MARK: - Initializers

    internal init(session: URLSession, route: HTTPRoute) {
        self.session = session
        self.route = route

        responseQueue = OperationQueue()

        responseQueue.maxConcurrentOperationCount = 1
        responseQueue.qualityOfService = .userInitiated
        responseQueue.isSuspended = true
    }

    // MARK: - Instance Methods

    internal func addResponseOperation(_ operation: @escaping (_ response: HTTPResponse<Data?>) -> Void) {
        responseQueue.addOperation {
            operation(self.response ?? HTTPResponse(.failure(HTTPError(code: .unknown))))
        }
    }

    internal func handleResponse(_ response: HTTPResponse<Data?>) {
        self.response = response

        responseQueue.isSuspended = false
    }

    internal func handleResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        var statusCode: HTTPStatusCode?
        var headers: [HTTPHeader]?

        if let response = response as? HTTPURLResponse {
            statusCode = HTTPStatusCode(rawValue: response.statusCode)

            headers = response.allHeaderFields.compactMap { (name, value) in
                guard let name = name as? String, let value = value as? String else {
                    return nil
                }

                return HTTPHeader(name: name, value: value)
            }
        }

        let result: Result<Data?, HTTPError>

        switch error {
        case let error as URLError:
            result = .failure(HTTPError(urlError: error, data: data))

        case let error?:
            result = .failure(HTTPError(code: .unknown, reason: error, data: data))

        case nil:
            if let error = HTTPError(statusCode: statusCode ?? 0, data: data) {
                result = .failure(error)
            } else {
                result = .success(data)
            }
        }

        handleResponse(HTTPResponse(result, statusCode: statusCode, headers: headers))
    }

    internal func serializeResponse<Serializer: HTTPResponseSerializer>(
        _ response: HTTPResponse<Data?>,
        serializer: Serializer
    ) -> HTTPResponse<Serializer.SerializedObject> {
        let result: Result<Serializer.SerializedObject, HTTPError> = response.result.flatMap { data in
            do {
                let statusCode = response.statusCode ?? 0
                let object: Serializer.SerializedObject

                if let data = data, !data.isEmpty {
                    object = try serializer.serialize(
                        data: data,
                        statusCode: statusCode,
                        method: self.route.method
                    )
                } else {
                    object = try serializer.serializeEmptyResponse(
                        statusCode: statusCode,
                        method: self.route.method
                    )
                }

                return .success(object)
            } catch {
                return .failure(HTTPError(code: .badResponse, reason: error, data: data))
            }
        }

        return HTTPResponse(result, statusCode: response.statusCode, headers: response.headers)
    }

    // MARK: -

    @discardableResult
    public func response(
        on queue: DispatchQueue,
        completion: @escaping (_ response: HTTPResponse<Data?>) -> Void
    ) -> Self {
        addResponseOperation { response in
            queue.async {
                completion(response)
            }
        }

        return self
    }

    @discardableResult
    public func response<Serializer: HTTPResponseSerializer>(
        on queue: DispatchQueue,
        serializer: Serializer,
        completion: @escaping (_ response: HTTPResponse<Serializer.SerializedObject>) -> Void
    ) -> Self {
        addResponseOperation { response in
            let serializedResponse = self.serializeResponse(response, serializer: serializer)

            queue.async {
                completion(serializedResponse)
            }
        }

        return self
    }

    @discardableResult
    public func responseData(
        on queue: DispatchQueue,
        completion: @escaping (_ response: HTTPResponse<Data>) -> Void
    ) -> Self {
        return response(
            on: queue,
            serializer: HTTPDataResponseSerializer(),
            completion: completion
        )
    }

    @discardableResult
    public func responseString(
        on queue: DispatchQueue,
        encoding: String.Encoding,
        completion: @escaping (_ response: HTTPResponse<String>) -> Void
    ) -> Self {
        return response(
            on: queue,
            serializer: HTTPStringResponseSerializer(encoding: encoding),
            completion: completion
        )
    }

    @discardableResult
    public func responseJSON(
        on queue: DispatchQueue,
        options: JSONSerialization.ReadingOptions,
        completion: @escaping (_ response: HTTPResponse<Any>) -> Void
    ) -> Self {
        return response(
            on: queue,
            serializer: HTTPJSONResponseSerializer(options: options),
            completion: completion
        )
    }

    @discardableResult
    public func responseDecodable<T: Decodable>(
        type: T.Type,
        on queue: DispatchQueue,
        decoder: HTTPResponseDecoder,
        completion: @escaping (_ response: HTTPResponse<T>) -> Void
    ) -> Self {
        return response(
            on: queue,
            serializer: HTTPDecodableResponseSerializer(decoder: decoder),
            completion: completion
        )
    }

    public func cancel() {
        sessionTask?.cancel()
    }
}

extension HTTPServiceTask: HTTPTask where SessionTask == URLSessionDataTask {

    // MARK: - Instance Methods

    @discardableResult
    internal func launch() -> Self {
        do {
            sessionTask = session.dataTask(with: try route.asRequest()) { data, response, error in
                self.handleResponse(response, data: data, error: error)
            }

            sessionTask?.resume()
        } catch {
            handleResponse(HTTPResponse(.failure(HTTPError(code: .badRequest, reason: error))))
        }

        return self
    }
}
