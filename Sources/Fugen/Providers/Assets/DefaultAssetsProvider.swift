import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultAssetsProvider: AssetsProvider {

    // MARK: - Instance Properties

    let dataProvider: DataProvider

    // MARK: - Initializers

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

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

    private func saveAssetFile(fileURL: URL, filePath: Path) -> Promise<Void> {
        return firstly {
            self.dataProvider.fetchData(from: fileURL)
        }.map { fileData in
            try filePath.write(fileData)
        }
    }

    private func saveAssetFiles(_ assetFiles: [URL: Path]) -> Promise<Void> {
        let promises = assetFiles.map { fileURL, filePath in
            saveAssetFile(fileURL: fileURL, filePath: filePath)
        }

        return when(fulfilled: promises)
    }

    private func makeAssetImageMetadate(for image: Image, folderPath: Path) -> AssetImageMetadata {
        let name = image.name.camelized

        let fileNames = image.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = "\(name)\(scale.assetFileNameSuffix).\(image.format.fileExtension)"
        }

        var filePaths: [URL: Path] = [:]

        fileNames.forEach { (scale, fileName) in
            if let imageURL = image.urls[scale] {
                filePaths[imageURL] = folderPath
                    .appending(fileName: name, extension: AssetImageSet.pathExtension)
                    .appending(fileName)
            }
        }

        return AssetImageMetadata(name: name, fileNames: fileNames, filePaths: filePaths)
    }

    // MARK: -

    func saveColorStyles(_ colorStyle: [ColorStyle], in folderPath: String) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            let folderPath = Path(folderPath)

            let folderContents = AssetFolderContents(info: .defaultFugen)
            var folder = AssetFolder(contents: folderContents)

            colorStyle.forEach { colorStyle in
                let assetColorName = colorStyle.name.camelized

                let assetColorComponents = AssetColorComponents(
                    red: colorStyle.color.red,
                    green: colorStyle.color.green,
                    blue: colorStyle.color.blue,
                    alpha: colorStyle.color.alpha
                )

                let assetColor = AssetColor(custom: .sRGB(components: assetColorComponents))

                let assetColorSetContents = AssetColorSetContents(
                    info: .defaultFugen,
                    colors: [assetColor]
                )

                folder.colorSets[assetColorName] = AssetColorSet(contents: assetColorSetContents)
            }

            try self.saveAssetFolder(folder, in: folderPath)
        }
    }

    func saveImages(_ images: [Image], in folderPath: String) -> Promise<Void> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            let folderPath = Path(folderPath)

            let folderContents = AssetFolderContents(info: .defaultFugen)
            var folder = AssetFolder(contents: folderContents)

            var assetFilePaths: [URL: Path] = [:]

            images.forEach { image in
                let assetImageMetadate = self.makeAssetImageMetadate(for: image, folderPath: folderPath)

                let assetImages = image.urls.keys.map { scale in
                    AssetImage(fileName: assetImageMetadate.fileNames[scale], scale: scale.assetImageScale)
                }

                let assetImageSetContents = AssetImageSetContents(
                    info: .defaultFugen,
                    images: assetImages
                )

                folder.imageSets[assetImageMetadate.name] = AssetImageSet(contents: assetImageSetContents)

                assetFilePaths.merge(assetImageMetadate.filePaths) { $1 }
            }

            try self.saveAssetFolder(folder, in: folderPath)

            return assetFilePaths
        }.then { assetFilePaths in
            self.saveAssetFiles(assetFilePaths)
        }
    }
}

private struct AssetImageMetadata {

    // MARK: - Instance Properties

    let name: String
    let fileNames: [ImageScale: String]
    let filePaths: [URL: Path]
}

private extension ImageScale {

    // MARK: - Instance Properties

    var assetFileNameSuffix: String {
        switch self {
        case .single, .scale1x:
            return ""

        case .scale2x:
            return "@2x"

        case .scale3x:
            return "@3x"

        case .scale4x:
            return "@4x"
        }
    }

    var assetImageScale: AssetImageScale? {
        switch self {
        case .single, .scale4x:
            return nil

        case .scale1x:
            return .scale1x

        case .scale2x:
            return .scale2x

        case .scale3x:
            return .scale3x
        }
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
