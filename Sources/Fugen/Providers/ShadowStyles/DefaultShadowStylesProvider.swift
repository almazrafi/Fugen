import Foundation
import PromiseKit

final class DefaultShadowStylesProvider: ShadowStylesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(filesProvider: FigmaFilesProvider, nodesProvider: FigmaNodesProvider) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractVector(from figmaEffect: FigmaEffect, of node: FigmaNode) throws -> Vector {
        guard let effectOffset = figmaEffect.offset else {
            throw ShadowStylesProviderError(code: .offsetNotFound, nodeID: node.id, nodeName: node.name)
        }

        return Vector(x: effectOffset.x, y: effectOffset.y)
    }

    private func extractColor(from figmaEffect: FigmaEffect, of node: FigmaNode) throws -> Color {
        guard let effectColor = figmaEffect.color else {
            throw ShadowStylesProviderError(code: .colorNotFound, nodeID: node.id, nodeName: node.name)
        }

        return Color(
            red: effectColor.red,
            green: effectColor.green,
            blue: effectColor.blue,
            alpha: effectColor.alpha
        )
    }

    private func extractShadowType(from effect: FigmaEffect) -> ShadowType? {
        switch effect.type {
        case .dropShadow:
            return .drop

        case .innerShadow:
            return .inner

        case .backgroundBlur, .layerBlur, nil:
            return nil
        }
    }

    private func extractShadow(from effect: FigmaEffect, of node: FigmaNode) throws -> Shadow? {
        guard let shadowType = extractShadowType(from: effect) else {
            return nil
        }

        return Shadow(
            type: shadowType,
            offset: try extractVector(from: effect, of: node),
            radius: effect.radius ?? 0.0,
            color: try extractColor(from: effect, of: node),
            blendMode: effect.rawBlendMode
        )
    }

    private func extractShadows(from nodeInfo: FigmaVectorNodeInfo, of node: FigmaNode) throws -> [Shadow] {
        let nodeEffects = nodeInfo.effects?.filter { nodeEffect in
            nodeEffect.isVisible ?? true
        } ?? []

        return try nodeEffects.compactMap { try extractShadow(from: $0, of: node) }
    }

    private func extractShadowStyleNode(
        from node: FigmaNode,
        styles: [String: FigmaStyle]
    ) throws -> ShadowStyleNode? {
        guard let nodeInfo = node.vectorInfo, let nodeStyleID = nodeInfo.styleID(of: .effect) else {
            return nil
        }

        let shadows = try extractShadows(from: nodeInfo, of: node)

        guard !shadows.isEmpty else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .effect else {
            throw ShadowStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ShadowStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
        }

        return ShadowStyleNode(
            name: nodeStyleName,
            description: nodeStyle.description,
            shadows: shadows
        )
    }

    private func extractShadowStyleNodes(
        from nodes: [FigmaNode],
        of file: FigmaFile
    ) throws -> [ShadowStyleNode] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
            .compactMap { try extractShadowStyleNode(from: $0, styles: styles) }
            .reduce(into: []) { result, node in
                if !result.contains(node) {
                    result.append(node)
                }
            }
    }

    // MARK: -

    func fetchShadowStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[ShadowStyle]> {
        firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractShadowStyleNodes(from: figmaNodes, of: figmaFile)
            }
        }.mapValues { node in
            ShadowStyle(node: node)
        }
    }
}
