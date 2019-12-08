import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultImageAssetsProvider: ImageAssetsProvider {

    // MARK: - Instance Properties

    let assetsProvider: AssetsProvider
    let dataProvider: DataProvider

    // MARK: - Initializers

    init(assetsProvider: AssetsProvider, dataProvider: DataProvider) {
        self.assetsProvider = assetsProvider
        self.dataProvider = dataProvider
    }

    // MARK: - Instance Methods

    private func makeAssetInfo(
        for info: ImageNodeInfo,
        format: ImageFormat,
        folderPath: Path
    ) -> ImageAssetInfo {
        let name = info.base.name.camelized

        let filePaths = info.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: name, extension: AssetImageSet.pathExtension)
                .appending(fileName: name.appending(scale.fileNameSuffix), extension: format.fileExtension)
                .string
        }

        return ImageAssetInfo(name: name, filePaths: filePaths)
    }

    private func makeAssetsInfo(
        for info: [ImageNodeInfo],
        format: ImageFormat,
        folderPath: Path
    ) -> [ImageNodeInfo: ImageAssetInfo] {
        var assetInfo: [ImageNodeInfo: ImageAssetInfo] = [:]

        info.forEach { info in
            assetInfo[info] = makeAssetInfo(for: info, format: format, folderPath: folderPath)
        }

        return assetInfo
    }

    private func makeAssetImageSet(assetInfo: ImageAssetInfo) -> AssetImageSet {
        let assetImages = assetInfo.filePaths.map { scale, filePath in
            AssetImage(fileName: Path(filePath).lastComponent, scale: scale.assetImageScale)
        }

        return AssetImageSet(contents: AssetImageSetContents(info: .defaultFugen, images: assetImages))
    }

    private func makeAssetImageSets(assetsInfo: [ImageNodeInfo: ImageAssetInfo]) -> [String: AssetImageSet] {
        return assetsInfo.values.reduce(into: [:]) { result, assetInfo in
            result[assetInfo.name] = makeAssetImageSet(assetInfo: assetInfo)
        }
    }

    private func saveImageFiles(info: ImageNodeInfo, assetInfo: ImageAssetInfo) -> Promise<Void> {
        let promises = info.urls.compactMap { scale, url in
            assetInfo.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(assetsInfo: [ImageNodeInfo: ImageAssetInfo]) -> Promise<Void> {
        let promises = assetsInfo.map { info, assetInfo in
            saveImageFiles(info: info, assetInfo: assetInfo)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageNodeInfo: ImageAssetInfo]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssetsInfo(
                for: info,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { assetsInfo in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    imageSets: self.makeAssetImageSets(assetsInfo: assetsInfo),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }.then {
                self.saveImageFiles(assetsInfo: assetsInfo)
            }
        }
    }
}

private extension ImageScale {

    // MARK: - Instance Properties

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
