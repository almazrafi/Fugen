import Foundation
import PromiseKit

protocol ImagesProvider {

    // MARK: - Instance Methods

    func fetchImages(
        from file: FileParameters,
        nodes: NodesParameters,
        parameters: ImagesParameters
    ) -> Promise<[Image]>
}
