import Foundation
import PromiseKit

final class DefaultColorStylesProvider: ColorStylesProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(
        apiProvider: FigmaAPIProvider,
        nodesProvider: FigmaNodesProvider
    ) {
        self.apiProvider = apiProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractColorStyle(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> ColorStyle? {
        guard let nodeInfo = node.vectorInfo, let nodeStyleID = nodeInfo.styleID(of: .fill) else {
            return nil
        }

        let nodeFills = nodeInfo.fills

        guard nodeFills?.count == 1, let nodeFill = nodeFills?.first(where: { $0.type == .solid }) else {
            return nil
        }

        guard let nodeFillColor = nodeFill.color else {
            throw ColorStylesProviderError.colorNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .fill else {
            throw ColorStylesProviderError.styleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ColorStylesProviderError.invalidStyleName(nodeName: node.name, nodeID: node.id)
        }

        return ColorStyle(
            name: nodeStyleName,
            color: Color(
                red: nodeFillColor.red,
                green: nodeFillColor.green,
                blue: nodeFillColor.blue,
                alpha: nodeFillColor.alpha
            )
        )
    }

    private func extractColorStyles(
        from file: FigmaFile,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?
    ) throws -> [ColorStyle] {
        return try nodesProvider
            .fetchNodes(from: file, including: includedNodeIDs, excluding: excludedNodeIDs)
            .lazy
            .compactMap { try extractColorStyle(from: $0, styles: file.styles ?? [:]) }
            .reduce(into: []) { result, colorStyle in
                if !result.contains(colorStyle) {
                    result.append(colorStyle)
                }
            }
    }

    // MARK: - ColorStylesProvider

    func fetchColorStyles(
        fileKey: String,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[ColorStyle]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey, accessToken: accessToken))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractColorStyles(
                from: file,
                includingNodes: includedNodeIDs,
                excludingNodes: excludedNodeIDs
            )
        }
    }
}
