import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]>
}
