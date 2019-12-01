import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultAssetsProvider: AssetsProvider {

    // MARK: - Instance Methods

    private func saveAssetFolder(_ folder: AssetFolder, in folderPath: Path) throws {
        let folderPathComponents = folderPath.components

        let parentFolderPath = folderPathComponents
            .lastIndex { $0.hasSuffix(.assetsExtension) }
            .map { $0..<folderPathComponents.count }?
            .lazy
            .map { Path(components: folderPathComponents.prefix(through: $0)) }
            .first { !AssetFolder.isValidFolder(at: $0.string) } ?? folderPath

        let parentFolder = folderPathComponents
            .suffix(from: parentFolderPath.components.count)
            .reversed()
            .reduce(folder) { folder, folderName in
                AssetFolder(folders: [folderName: folder], contents: folder.contents)
            }

        try parentFolder.save(in: parentFolderPath.string)
    }

    // MARK: -

    func saveAssetFolder(_ folder: AssetFolder, in folderPath: String) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            try self.saveAssetFolder(folder, in: Path(folderPath))
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let assetsExtension = "xcassets"
}
