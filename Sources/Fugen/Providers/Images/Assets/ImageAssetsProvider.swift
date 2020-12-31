import Foundation
import PromiseKit

protocol ImageAssetsProvider {

    // MARK: - Instance Methods

    func saveImages(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageAsset]>
}
