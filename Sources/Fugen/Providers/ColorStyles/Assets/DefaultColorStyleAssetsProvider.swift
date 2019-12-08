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

    private func makeAssetInfo(for info: ColorStyleNodeInfo) -> ColorStyleAssetInfo {
        return ColorStyleAssetInfo(name: info.name.camelized)
    }

    private func makeAssetsInfo(for info: [ColorStyleNodeInfo]) -> [ColorStyleNodeInfo: ColorStyleAssetInfo] {
        var assetInfo: [ColorStyleNodeInfo: ColorStyleAssetInfo] = [:]

        info.forEach { info in
            assetInfo[info] = makeAssetInfo(for: info)
        }

        return assetInfo
    }

    private func makeAssetColorSet(info: ColorStyleNodeInfo) -> AssetColorSet {
        let color = info.color

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

    private func makeAssetColorSets(assetInfo: [ColorStyleNodeInfo: ColorStyleAssetInfo]) -> [String: AssetColorSet] {
        return assetInfo.reduce(into: [:]) { result, assetsInfo in
            result[assetsInfo.value.name] = makeAssetColorSet(info: assetsInfo.key)
        }
    }

    // MARK: -

    func saveColorStyles(
        info: [ColorStyleNodeInfo],
        in folderPath: String
    ) -> Promise<[ColorStyleNodeInfo: ColorStyleAssetInfo]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssetsInfo(for: info)
        }.nest { assetsInfo in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    colorSets: self.makeAssetColorSets(assetInfo: assetsInfo),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }
        }
    }
}
