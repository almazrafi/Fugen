import Foundation

public final class HTTPQueryURLEncoder: HTTPQueryEncoder {

    // MARK: - Type Properties

    public static let `default` = HTTPQueryURLEncoder(urlEncoder: URLEncoder())

    // MARK: - Instance Properties

    public let urlEncoder: URLEncoder

    // MARK: - Initializers

    public init(urlEncoder: URLEncoder) {
        self.urlEncoder = urlEncoder
    }

    // MARK: - Instance Methods

    public func encode<T: Encodable>(url: URL, parameters: T) throws -> URL {
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            throw MessageError("Invalid URL")
        }

        let query = [
            urlComponents.percentEncodedQuery,
            try urlEncoder.encodeToQuery(parameters)
        ]

        urlComponents.percentEncodedQuery = query
            .compactMap { $0 }
            .joined(separator: .querySeparator)

        guard let url = urlComponents.url else {
            throw MessageError("Invalid query parameters")
        }

        return url
    }
}

private extension String {

    // MARK: - Type Properties

    static let querySeparator = "&"
}
