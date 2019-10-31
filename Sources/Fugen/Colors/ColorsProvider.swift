import Foundation
import PromiseKit

protocol ColorsProvider {

    // MARK: - Instance Methods

    func fetchColors(
        fileKey: String,
        accessToken: String,
        includingNodes includingNodeIDs: [String],
        excludingNodes excludingNodeIDs: [String]
    ) -> Promise<[Color]>
}
