import Foundation
import PromiseKit

protocol ImageAssetsProvider {

    // MARK: - Instance Methods

    func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageNodeInfo: ImageAssetInfo]>
}
