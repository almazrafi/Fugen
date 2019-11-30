import Foundation
import PromiseKit

protocol ColorStylesProvider {

    // MARK: - Instance Methods

    func fetchColorStyles(from file: FileParameters, nodes: NodesParameters, assets: String?) -> Promise<[ColorStyle]>
}
