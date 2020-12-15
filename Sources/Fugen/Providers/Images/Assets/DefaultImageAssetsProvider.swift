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

    private func makeAsset(
        for node: ImageRenderedNode,
        format: ImageFormat,
        preserveVectorData: Bool,
        folderPath: Path
    ) -> ImageAsset {
        let name = node.base.name.camelized

        let filePaths = node.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: name, extension: AssetImageSet.pathExtension)
                .appending(fileName: name.appending(scale.fileNameSuffix), extension: format.fileExtension)
                .string
        }

        return ImageAsset(name: name, filePaths: filePaths, preserveVectorData: preserveVectorData)
    }

    private func makeAssets(
        for nodes: [ImageRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        folderPath: Path
    ) -> [ImageRenderedNode: ImageAsset] {
        var assets: [ImageRenderedNode: ImageAsset] = [:]

        nodes.forEach { node in
            assets[node] = makeAsset(
                for: node,
                format: format,
                preserveVectorData: preserveVectorData,
                folderPath: folderPath
            )
        }

        return assets
    }

    private func makeAssetImageSet(for asset: ImageAsset) -> AssetImageSet {
        let assetImages = asset.filePaths.map { scale, filePath in
            AssetImage(fileName: Path(filePath).lastComponent, scale: scale.assetImageScale)
        }
        let contents = AssetImageSetContents(
            info: .defaultFugen,
            properties: AssetImageProperties(from: asset),
            images: assetImages
        )
        return AssetImageSet(contents: contents)
    }

    private func makeAssetImageSets(for assets: [ImageRenderedNode: ImageAsset]) -> [String: AssetImageSet] {
        return assets.values.reduce(into: [:]) { result, asset in
            result[asset.name] = makeAssetImageSet(for: asset)
        }
    }

    private func saveImageFiles(node: ImageRenderedNode, asset: ImageAsset) -> Promise<Void> {
        let promises = node.urls.compactMap { scale, url in
            asset.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(assets: [ImageRenderedNode: ImageAsset]) -> Promise<Void> {
        let promises = assets.map { node, asset in
            saveImageFiles(node: node, asset: asset)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageAsset]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssets(
                for: nodes,
                format: format,
                preserveVectorData: preserveVectorData,
                folderPath: Path(folderPath)
            )
        }.nest { assets in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    imageSets: self.makeAssetImageSets(for: assets),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }.then {
                self.saveImageFiles(assets: assets)
            }
        }
    }
}

private extension ImageScale {

    // MARK: - Instance Properties

    var assetImageScale: AssetImageScale? {
        switch self {
        case .none:
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

private extension AssetImageProperties {

    init?(from imageAsset: ImageAsset) {
        guard imageAsset.preserveVectorData else {
            return nil
        }
        self.init(preserveVectorRepresentation: imageAsset.preserveVectorData)
    }
}
