import Foundation
import PromiseKit

protocol FigmaNodesProvider {

    // MARK: - Instance Methods

    func fetchNodes(_ nodes: NodesParameters, from file: FigmaFile) -> Promise<[FigmaNode]>
}
