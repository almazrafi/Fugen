import Foundation
import FugenTools
import PromiseKit

protocol AssetsProvider {

    // MARK: - Instance Methods

    func saveAssetFolder(_ folder: AssetFolder, in folderPath: String) -> Promise<Void>
}
