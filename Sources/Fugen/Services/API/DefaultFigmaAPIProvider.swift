import Foundation
import PromiseKit
import FugenTools

final class DefaultFigmaAPIProvider: FigmaAPIProvider {

    // MARK: - Instance Properties

    private let queryEncoder: HTTPQueryEncoder
    private let bodyEncoder: HTTPBodyEncoder
    private let responseDecoder: HTTPResponseDecoder

    // MARK: -

    let apiService: FigmaAPIService

    let serverBaseURL: URL
    let accessToken: String

    // MARK: - Initializers

    init(
        apiService: FigmaAPIService,
        serverBaseURL: URL,
        accessToken: String
    ) {
        self.apiService = apiService

        self.serverBaseURL = serverBaseURL
        self.accessToken = accessToken

        let urlEncoder = URLEncoder()
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()

        urlEncoder.dateEncodingStrategy = .formatted(.figmaAPI)
        jsonEncoder.dateEncodingStrategy = .formatted(.figmaAPI)
        jsonDecoder.dateDecodingStrategy = .formatted(.figmaAPI)

        self.queryEncoder = HTTPQueryURLEncoder(urlEncoder: urlEncoder)
        self.bodyEncoder = HTTPBodyJSONEncoder(jsonEncoder: jsonEncoder)
        self.responseDecoder = jsonDecoder
    }

    // MARK: - Instance Methods

    private func makeHTTPRoute<Route: FigmaAPIRoute>(for route: Route) -> HTTPRoute {
        let url = serverBaseURL
            .appendingPathComponent(route.apiVersion.urlPath)
            .appendingPathComponent(route.urlPath)

        let headers = [HTTPHeader.figmaAccessToken(accessToken)]

        return HTTPRoute(
            method: route.httpMethod,
            url: url,
            headers: headers,
            queryParameters: route.queryParameters,
            queryEncoder: queryEncoder,
            bodyParameters: route.bodyParameters,
            bodyEncoder: bodyEncoder
        )
    }

    private func handleHTTPError(_ error: HTTPError) -> Error {
        guard let errorData = error.data, error.reason is HTTPStatusCode else {
            return error
        }

        guard let apiError = try? responseDecoder.decode(FigmaAPIError.self, from: errorData) else {
            return error
        }

        return apiError
    }

    // MARK: -

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Void> where Route.Response == FigmaAPIEmptyResponse {
        return Promise { seal in
            let task = apiService.request(route: makeHTTPRoute(for: route))

            task.response { response in
                switch response.result {
                case let .failure(error):
                    seal.reject(self.handleHTTPError(error))

                case .success:
                    seal.fulfill(Void())
                }
            }
        }
    }

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Route.Response> {
        return Promise { seal in
            let task = apiService.request(route: makeHTTPRoute(for: route))

            task.responseDecodable(type: Route.Response.self, decoder: responseDecoder) { response in
                switch response.result {
                case let .failure(error):
                    seal.reject(self.handleHTTPError(error))

                case let .success(value):
                    seal.fulfill(value)
                }
            }
        }
    }
}

private extension HTTPHeader {

    // MARK: - Type Methods

    static func figmaAccessToken(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "X-Figma-Token", value: value)
    }
}

private extension DateFormatter {

    // MARK: - Type Properties

    static let figmaAPI: DateFormatter = {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent

        return dateFormatter
    }()
}
