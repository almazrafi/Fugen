import Foundation
import PromiseKit

protocol ShadowStylesProvider {

    // MARK: - Instance Methods

    func fetchShadowStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[ShadowStyle]>
}
