import Foundation
import FugenTools
import PromiseKit

protocol AssetsProvider {

    // MARK: - Instance Methods

    func saveColorStyles(_ colorStyle: [ColorStyle], in folderPath: String) -> Promise<Void>
    func saveImages(_ images: [Image], in folderPath: String) -> Promise<Void>
}
