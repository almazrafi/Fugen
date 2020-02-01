import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultColorStyleAssetsProvider: ColorStyleAssetsProvider {

    // MARK: - Instance Properties

    let assetsProvider: AssetsProvider

    // MARK: - Initializers

    init(assetsProvider: AssetsProvider) {
        self.assetsProvider = assetsProvider
    }

    // MARK: - Instance Methods

    private func makeAsset(for node: ColorStyleNode) -> ColorStyleAsset {
        return ColorStyleAsset(name: node.name.camelized)
    }

    private func makeAssets(for nodes: [ColorStyleNode]) -> [ColorStyleNode: ColorStyleAsset] {
        var assets: [ColorStyleNode: ColorStyleAsset] = [:]

        nodes.forEach { node in
            assets[node] = makeAsset(for: node)
        }

        return assets
    }

    private func makeAssetColorSet(for node: ColorStyleNode) -> AssetColorSet {
        let color = node.color

        let assetColorComponents = AssetColorComponents(
            red: color.red,
            green: color.green,
            blue: color.blue,
            alpha: color.alpha
        )

        let assetColor = AssetColor(custom: .sRGB(components: assetColorComponents))

        let assetColorSetContents = AssetColorSetContents(
            info: .defaultFugen,
            colors: [assetColor]
        )

        return AssetColorSet(contents: assetColorSetContents)
    }

    private func makeAssetColorSets(for assets: [ColorStyleNode: ColorStyleAsset]) -> [String: AssetColorSet] {
        return assets.reduce(into: [:]) { result, asset in
            result[asset.value.name] = makeAssetColorSet(for: asset.key)
        }
    }

    // MARK: -

    func saveColorStyles(nodes: [ColorStyleNode], in folderPath: String) -> Promise<[ColorStyleNode: ColorStyleAsset]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssets(for: nodes)
        }.nest { assets in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    colorSets: self.makeAssetColorSets(for: assets),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }
        }
    }
}
