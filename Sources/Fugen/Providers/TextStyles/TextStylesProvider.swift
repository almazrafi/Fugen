import Foundation
import PromiseKit

protocol TextStylesProvider {

    // MARK: - Instance Methods

    func fetchTextStyles(
        fileKey: String,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[TextStyle]>
}
