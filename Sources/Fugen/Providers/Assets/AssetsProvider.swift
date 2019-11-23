import Foundation
import FugenTools

protocol AssetsProvider {

    // MARK: - Instance Methods

    func saveColorStyles(_ colorStyle: [ColorStyle], in folderPath: String) throws
}
