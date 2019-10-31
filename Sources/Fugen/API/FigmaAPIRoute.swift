import Foundation
import FugenTools

protocol FigmaAPIRoute {

    // MARK: - Nested Types

    associatedtype QueryParameters: Encodable
    associatedtype BodyParameters: Encodable
    associatedtype Response: Decodable

    // MARK: - Instance Properties

    var apiVersion: FigmaAPIVersion { get }
    var httpMethod: HTTPMethod { get }
    var urlPath: String { get }
    var accessToken: String? { get }
    var queryParameters: QueryParameters? { get }
    var bodyParameters: BodyParameters? { get }
}

extension FigmaAPIRoute {

    // MARK: - Instance Properties

    var apiVersion: FigmaAPIVersion {
        .v1
    }

    var httpMethod: HTTPMethod {
        .get
    }

    var accessToken: String? {
        nil
    }
}

extension FigmaAPIRoute where QueryParameters == FigmaAPIEmptyParameters {

    // MARK: - Instance Properties

    var queryParameters: QueryParameters? {
        nil
    }
}

extension FigmaAPIRoute where BodyParameters == FigmaAPIEmptyParameters {

    // MARK: - Instance Properties

    var bodyParameters: BodyParameters? {
        nil
    }
}
