import Foundation
import FugenTools

public protocol FigmaHTTPService {

    // MARK: - Instance Methods

    func request(route: HTTPRoute) -> HTTPTask
}

extension HTTPService: FigmaHTTPService { }
