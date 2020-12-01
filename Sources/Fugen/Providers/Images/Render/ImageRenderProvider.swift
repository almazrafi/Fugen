import Foundation
import PromiseKit

protocol ImageRenderProvider {

    // MARK: - Instance Methods

    func renderImages(
        of file: FileParameters,
        nodes: [ImageNode],
        format: ImageFormat,
        scales: [ImageScale],
        useAbsoluteBounds: Bool
    ) -> Promise<[ImageRenderedNode]>
}
