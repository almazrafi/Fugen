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

        let nodeFills = nodeInfo.fills?.filter { nodeFill in
            (nodeFill.isVisible ?? true) && (nodeFill.type == .solid)
        } ?? []

        guard let nodeFill = nodeFills.first, nodeFills.count == 1 else {
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
            name: nodeStyleName,
            description: nodeStyle.description,
            color: Color(
                red: nodeFillColor.red,
                green: nodeFillColor.green,
                blue: nodeFillColor.blue,
                alpha: nodeFill.opacity ?? nodeFillColor.alpha
            )
        )
    }

    private func extractColorStyleNodes(from nodes: [FigmaNode], of file: FigmaFile) throws -> [ColorStyleNode] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
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
                try self.extractColorStyleNodes(from: figmaNodes, of: figmaFile)
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
