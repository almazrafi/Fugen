import Foundation
import PromiseKit

protocol ColorsProvider {

    // MARK: - Instance Methods

    func fetchColors(
        fileKey: String,
        excludingNodes excludingNodeIDs: [String],
        includingNodes includingNodeIDs: [String]
    ) -> Promise<[Color]>
}
