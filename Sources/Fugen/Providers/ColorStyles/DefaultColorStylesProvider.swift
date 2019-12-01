import Foundation
import PromiseKit

final class DefaultColorStylesProvider: ColorStylesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider
    let colorStyleAssetsProvider: ColorStyleAssetsProvider

    // MARK: - Initializers

    init(
        filesProvider: FigmaFilesProvider,
        nodesProvider: FigmaNodesProvider,
        colorStyleAssetsProvider: ColorStyleAssetsProvider
    ) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
        self.colorStyleAssetsProvider = colorStyleAssetsProvider
    }

    // MARK: - Instance Methods

    private func extractColorStyleInfo(
        from node: FigmaNode,
        styles: [String: FigmaStyle]
    ) throws -> ColorStyleNodeInfo? {
        guard let nodeInfo = node.vectorInfo, let nodeStyleID = nodeInfo.styleID(of: .fill) else {
            return nil
        }

        let nodeFills = nodeInfo.fills

        guard nodeFills?.count == 1, let nodeFill = nodeFills?.first(where: { $0.type == .solid }) else {
            return nil
        }

        guard let nodeFillColor = nodeFill.color else {
            throw ColorStylesProviderError(code: .colorNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .fill else {
            throw ColorStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ColorStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
        }

        return ColorStyleNodeInfo(
            id: node.id,
            name: nodeStyleName,
            description: nodeStyle.description,
            color: Color(
                red: nodeFillColor.red,
                green: nodeFillColor.green,
                blue: nodeFillColor.blue,
                alpha: nodeFillColor.alpha
            )
        )
    }

    private func extractColorStylesInfo(from nodes: [FigmaNode], of file: FigmaFile) throws -> [ColorStyleNodeInfo] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .compactMap { try extractColorStyleInfo(from: $0, styles: styles) }
            .reduce(into: []) { result, colorStyle in
                if !result.contains(colorStyle) {
                    result.append(colorStyle)
                }
            }
    }

    private func saveColorStyles(
        info: [ColorStyleNodeInfo],
        assets: String?
    ) -> Promise<[ColorStyleNodeInfo: ColorStyleAssetInfo]> {
        guard let folderPath = assets else {
            return .value([:])
        }

        return colorStyleAssetsProvider.saveColorStyles(info: info, in: folderPath)
    }

    private func makeColorStyles(
        info: [ColorStyleNodeInfo],
        assetsInfo: [ColorStyleNodeInfo: ColorStyleAssetInfo]
    ) -> [ColorStyle] {
        return info.map { info in
            ColorStyle(info: info, assetInfo: assetsInfo[info])
        }
    }

    // MARK: -

    func fetchColorStyles(from file: FileParameters, nodes: NodesParameters, assets: String?) -> Promise<[ColorStyle]> {
        return firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractColorStylesInfo(from: figmaNodes, of: figmaFile)
            }
        }.then { info in
            firstly {
                self.saveColorStyles(info: info, assets: assets)
            }.map { assetsInfo in
                self.makeColorStyles(info: info, assetsInfo: assetsInfo)
            }
        }
    }
}
