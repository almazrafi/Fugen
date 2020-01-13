import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class HTTPService {

    // MARK: - Instance Properties

    private let session: URLSession

    // MARK: -

    public var sessionConfiguration: URLSessionConfiguration {
        session.configuration
    }

    public var activityIndicator: HTTPActivityIndicator?

    // MARK: - Initializers

    public init(
        sessionConfiguration: URLSessionConfiguration = .httpServiceDefault,
        activityIndicator: HTTPActivityIndicator? = nil
    ) {
        self.session = URLSession(configuration: sessionConfiguration)
        self.activityIndicator = activityIndicator
    }

    // MARK: - Instance Methods

    public func request(route: HTTPRoute) -> HTTPTask {
        DispatchQueue.main.async {
            self.activityIndicator?.incrementActivityCount()
        }

        return HTTPServiceTask<URLSessionDataTask>(session: session, route: route)
            .launch()
            .response { _ in
                DispatchQueue.main.async {
                    self.activityIndicator?.decrementActivityCount()
                }
            }
    }
}

extension URLSessionConfiguration {

    // MARK: - Type Properties

    public static var httpServiceDefault: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default

        let headers = [
            HTTPHeader.defaultAcceptLanguage(),
            HTTPHeader.defaultAcceptEncoding(),
            HTTPHeader.defaultUserAgent()
        ]

        let rawHeaders = Dictionary(uniqueKeysWithValues: headers.map { ($0.name, $0.value) })

        configuration.httpAdditionalHeaders = rawHeaders
        configuration.timeoutIntervalForRequest = 45

        return configuration
    }
}
