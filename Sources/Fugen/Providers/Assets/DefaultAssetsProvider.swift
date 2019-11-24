import Foundation
import FugenTools
import PathKit

final class DefaultAssetsProvider: AssetsProvider {

    // MARK: - Instance Methods

    private func saveAssetFolder(_ folder: AssetFolder, at folderPath: String) throws {
        let folderPath = Path(folderPath)
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

    func saveColorStyles(_ colorStyle: [ColorStyle], in folderPath: String) throws {
        let folderContents = AssetFolderContents(info: .defaultFugen)
        var folder = AssetFolder(contents: folderContents)

        colorStyle.forEach { colorStyle in
            let colorComponents = AssetColorComponents(
                red: colorStyle.color.red,
                green: colorStyle.color.green,
                blue: colorStyle.color.blue,
                alpha: colorStyle.color.alpha
            )

            let color = AssetColor(custom: .sRGB(components: colorComponents))
            let colorSetContents = AssetColorSetContents(info: .defaultFugen, colors: [color])

            folder.colorSets[colorStyle.name.camelized] = AssetColorSet(contents: colorSetContents)
        }

        try saveAssetFolder(folder, at: folderPath)
    }
}

private extension AssetInfo {

    // MARK: - Type Properties

    static let defaultFugen = AssetInfo(version: 1, author: "Fugen")
}

private extension String {

    // MARK: - Type Properties

    static let assetsExtension = "xcassets"
}
