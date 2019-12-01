import Foundation
import PromiseKit

protocol ImageResourcesProvider {

    // MARK: - Instance Methods

    func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageNodeInfo: ImageResourceInfo]>
}
