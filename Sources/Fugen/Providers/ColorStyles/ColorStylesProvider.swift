import Foundation
import PromiseKit

protocol ColorStylesProvider {

    // MARK: - Instance Methods

    func fetchColorStyles(
        fileKey: String,
        accessToken: String,
        includingNodes includingNodeIDs: [String],
        excludingNodes excludingNodeIDs: [String]
    ) -> Promise<[ColorStyle]>
}
