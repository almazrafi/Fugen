import Foundation
import PromiseKit

protocol FigmaAPIProvider {

    // MARK: - Instance Methods

    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Void> where Route.Response == FigmaAPIEmptyResponse
    func request<Route: FigmaAPIRoute>(route: Route) -> Promise<Route.Response>
}
