import Foundation
import PromiseKit

protocol ColorStyleAssetsProvider {

    // MARK: - Instance Methods

    func saveColorStyles(
        info: [ColorStyleNodeInfo],
        in folderPath: String
    ) -> Promise<[ColorStyleNodeInfo: ColorStyleAssetInfo]>
}
