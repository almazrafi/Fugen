import Foundation
import PromiseKit

protocol ImagesProvider {

    // MARK: - Instance Methods

    func fetchImages(
        fileKey: String,
        fileVersion: String?,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        format: ImageFormat,
        scales: [ImageScale],
        accessToken: String
    ) -> Promise<[Image]>
}
