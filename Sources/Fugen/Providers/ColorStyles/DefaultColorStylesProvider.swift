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
            throw ColorStylesProviderError(code: .colorNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .fill else {
            throw ColorStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ColorStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
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

    // MARK: -

    func fetchColorStyles(
        fileKey: String,
        fileVersion: String?,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[ColorStyle]> {
        let route = FigmaAPIFileRoute(
            accessToken: accessToken,
            fileKey: fileKey,
            version: fileVersion
        )

        return firstly {
            self.apiProvider.request(route: route)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractColorStyles(
                from: file,
                includingNodes: includedNodeIDs,
                excludingNodes: excludedNodeIDs
            )
        }
    }
}
