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

    private func makeAssetImageContext(
        info: ImageNodeInfo,
        format: ImageFormat,
        folderPath: Path
    ) -> AssetImageContext {
        let name = info.base.name.camelized

        let filePaths = info.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: name, extension: AssetImageSet.pathExtension)
                .appending(fileName: name.appending(scale.fileNameSuffix), extension: format.fileExtension)
        }

        return AssetImageContext(info: info, name: name, filePaths: filePaths)
    }

    private func makeAssetImageContexts(
        info: [ImageNodeInfo],
        format: ImageFormat,
        folderPath: Path
    ) -> [AssetImageContext] {
        return info.map { makeAssetImageContext(info: $0, format: format, folderPath: folderPath) }
    }

    private func makeAssetImageSet(for context: AssetImageContext) -> AssetImageSet {
        let assetImages = context.filePaths.map { scale, filePath in
            AssetImage(fileName: filePath.lastComponent, scale: scale.assetImageScale)
        }

        return AssetImageSet(contents: AssetImageSetContents(info: .defaultFugen, images: assetImages))
    }

    private func makeAssetImageSets(for contexts: [AssetImageContext]) -> [String: AssetImageSet] {
        return contexts.reduce(into: [:]) { result, context in
            result[context.name] = makeAssetImageSet(for: context)
        }
    }

    private func saveAssetImageFiles(context: AssetImageContext) -> Promise<Void> {
        let promises = context.info.urls.compactMap { scale, url in
            context.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0.string) }
        }

        return when(fulfilled: promises)
    }

    private func saveAssetImageFiles(contexts: [AssetImageContext]) -> Promise<Void> {
        let promises = contexts.map { context in
            saveAssetImageFiles(context: context)
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
            self.makeAssetImageContexts(
                info: info,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { contexts in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    imageSets: self.makeAssetImageSets(for: contexts),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }.then {
                self.saveAssetImageFiles(contexts: contexts)
            }
        }.mapValues { context in
            (context.info, ImageAssetInfo(name: context.name))
        }.map { items in
            Dictionary(items) { $1 }
        }
    }
}

private struct AssetImageContext {

    // MARK: - Instance Properties

    let info: ImageNodeInfo
    let name: String
    let filePaths: [ImageScale: Path]
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
