import Foundation
import PromiseKit
import FugenTools

final class DefaultFigmaAPIProvider: FigmaAPIProvider {

    // MARK: - Instance Properties

    private let queryEncoder: HTTPQueryEncoder
    private let bodyEncoder: HTTPBodyEncoder
    private let responseDecoder: HTTPResponseDecoder

    // MARK: -

    let httpService: FigmaHTTPService

    // MARK: - Initializers

    init(httpService: FigmaHTTPService) {
        self.httpService = httpService

        let urlEncoder = URLEncoder(boolEncodingStrategy: .literal)
        let jsonEncoder = JSONEncoder()
        let jsonDecoder = JSONDecoder()

        urlEncoder.dateEncodingStrategy = .formatted(.figmaAPI(withMilliseconds: true))
        jsonEncoder.dateEncodingStrategy = .formatted(.figmaAPI(withMilliseconds: true))

        jsonDecoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            if let date = DateFormatter.figmaAPI(withMilliseconds: true).date(from: dateString) {
                return date
            }

            if let date = DateFormatter.figmaAPI(withMilliseconds: false).date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Date string does not match format expected by formatter"
            )
        }

        self.queryEncoder = HTTPQueryURLEncoder(urlEncoder: urlEncoder)
        self.bodyEncoder = HTTPBodyJSONEncoder(jsonEncoder: jsonEncoder)
        self.responseDecoder = jsonDecoder
    }

    // MARK: - Instance Methods

    private func makeHTTPRoute<Route: FigmaAPIRoute>(for route: Route) -> HTTPRoute {
        let url = URL.figmaAPIServer
            .appendingPathComponent(route.apiVersion.urlPath)
            .appendingPathComponent(route.urlPath)

        let headers = route.accessToken.map { [HTTPHeader.figmaAccessToken($0)] } ?? []

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

        guard let apiError = try? responseDecoder.decode(FigmaError.self, from: errorData) else {
            return error
        }

        return apiError
    }

    // MARK: -

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Void> where Route.Response == FigmaAPIEmptyResponse {
        return Promise { seal in
            let task = httpService.request(route: makeHTTPRoute(for: route))

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
            let task = httpService.request(route: makeHTTPRoute(for: route))

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

    static func figmaAPI(withMilliseconds: Bool) -> DateFormatter {
        let dateFormatter = DateFormatter()

        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        if withMilliseconds {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        }

        return dateFormatter
    }
}

private extension URL {

    // MARK: - Type Properties

    static let figmaAPIServer = URL(string: "https://api.figma.com")!
}
