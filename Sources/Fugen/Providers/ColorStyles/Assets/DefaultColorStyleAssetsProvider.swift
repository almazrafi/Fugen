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

    private func makeAssetColorStyleContext(info: ColorStyleNodeInfo) -> AssetColorStyleContext {
        return AssetColorStyleContext(info: info, name: info.name.camelized)
    }

    private func makeAssetColorStyleContexts(info: [ColorStyleNodeInfo]) -> [AssetColorStyleContext] {
        return info.map { makeAssetColorStyleContext(info: $0) }
    }

    private func makeAssetColorSet(for context: AssetColorStyleContext) -> AssetColorSet {
        let color = context.info.color

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

    private func makeAssetColorSets(for contexts: [AssetColorStyleContext]) -> [String: AssetColorSet] {
        return contexts.reduce(into: [:]) { result, context in
            result[context.name] = makeAssetColorSet(for: context)
        }
    }

    // MARK: -

    func saveColorStyles(
        info: [ColorStyleNodeInfo],
        in folderPath: String
    ) -> Promise<[ColorStyleNodeInfo: ColorStyleAssetInfo]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeAssetColorStyleContexts(info: info)
        }.nest { contexts in
            perform(on: DispatchQueue.global(qos: .userInitiated)) {
                AssetFolder(
                    colorSets: self.makeAssetColorSets(for: contexts),
                    contents: AssetFolderContents(info: .defaultFugen)
                )
            }.then { folder in
                self.assetsProvider.saveAssetFolder(folder, in: folderPath)
            }
        }.mapValues { context in
            (context.info, ColorStyleAssetInfo(name: context.name))
        }.map { items in
            Dictionary(items) { $1 }
        }
    }
}

private struct AssetColorStyleContext {

    // MARK: - Instance Properties

    let info: ColorStyleNodeInfo
    let name: String
}
