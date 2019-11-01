import Foundation
import PromiseKit

protocol TextStylesProvider {

    // MARK: - Instance Methods

    func fetchTextStyles(
        fileKey: String,
        accessToken: String,
        includingNodes includingNodeIDs: [String],
        excludingNodes excludingNodeIDs: [String]
    ) -> Promise<[TextStyle]>
}
