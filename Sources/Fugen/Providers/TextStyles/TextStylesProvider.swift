import Foundation
import PromiseKit

protocol TextStylesProvider {

    // MARK: - Instance Methods

    func fetchTextStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[TextStyle]>
}
