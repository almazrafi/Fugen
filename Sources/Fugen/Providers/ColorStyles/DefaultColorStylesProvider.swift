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

    private func extractColorStyleNode(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> ColorStyleNode? {
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

        return ColorStyleNode(
            id: nodeStyleID,
            name: nodeStyleName,
            description: nodeStyle.description,
            opacity: nodeFill.opacity,
            color: Color(
                red: nodeFillColor.red,
                green: nodeFillColor.green,
                blue: nodeFillColor.blue,
                alpha: nodeFillColor.alpha
            )
        )
    }

    private func extractColorStylesNodes(from nodes: [FigmaNode], of file: FigmaFile) throws -> [ColorStyleNode] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .compactMap { try extractColorStyleNode(from: $0, styles: styles) }
            .reduce(into: []) { result, node in
                if !result.contains(node) {
                    result.append(node)
                }
            }
    }

    private func saveAssetColorStylesIfNeeded(
        nodes: [ColorStyleNode],
        in assets: String?
    ) -> Promise<[ColorStyleNode: ColorStyleAsset]> {
        guard let folderPath = assets else {
            return .value([:])
        }

        return colorStyleAssetsProvider.saveColorStyles(nodes: nodes, in: folderPath)
    }

    // MARK: -

    func fetchColorStyles(
        from file: FileParameters,
        nodes: NodesParameters,
        assets: String?
    ) -> Promise<[ColorStyle]> {
        return firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractColorStylesNodes(from: figmaNodes, of: figmaFile)
            }
        }.then { nodes in
            firstly {
                self.saveAssetColorStylesIfNeeded(nodes: nodes, in: assets)
            }.map { assets in
                nodes.map { node in
                    ColorStyle(node: node, asset: assets[node])
                }
            }
        }
    }
}
