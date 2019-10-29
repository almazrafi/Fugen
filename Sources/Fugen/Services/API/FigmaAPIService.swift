import Foundation
import FugenTools

public protocol FigmaAPIService {

    // MARK: - Instance Methods

    func request(route: HTTPRoute) -> HTTPTask
}

extension HTTPService: FigmaAPIService { }
