import Foundation
import PromiseKit

protocol ColorStyleAssetsProvider {

    // MARK: - Instance Methods

    func saveColorStyles(nodes: [ColorStyleNode], in folderPath: String) -> Promise<[ColorStyleNode: ColorStyleAsset]>
}
