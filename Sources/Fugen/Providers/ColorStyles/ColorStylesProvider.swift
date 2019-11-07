import Foundation
import PromiseKit

protocol ColorStylesProvider {

    // MARK: - Instance Methods

    func fetchColorStyles(
        fileKey: String,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[ColorStyle]>
}
