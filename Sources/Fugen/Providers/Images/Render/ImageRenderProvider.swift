import Foundation
import PromiseKit

protocol ImageRenderProvider {

    // MARK: - Instance Methods

    func renderImages(
        of file: FileParameters,
        info: [ImageNodeBaseInfo],
        format: ImageFormat,
        scales: [ImageScale]
    ) -> Promise<[ImageNodeInfo]>
}
