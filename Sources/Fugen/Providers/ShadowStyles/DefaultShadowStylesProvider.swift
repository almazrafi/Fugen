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

    private func extractShadowStyles(from nodes: [FigmaNode], of file: FigmaFile) throws -> [ShadowStyle] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .compactMap { try extractShadowStyle(from: $0, styles: styles) }
            .reduce(into: [], { result, shadowStyle in
                if !result.contains(shadowStyle) {
                    result.append(shadowStyle)
                }
            })
    }

    private func extractShadowStyle(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> ShadowStyle? {
        guard case let .vector(info: nodeInfo) = node.type else {
            return nil
        }

        guard let nodeStyleID = nodeInfo.styleID(of: .effect) else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .effect else {
            throw ShadowStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw ShadowStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
        }

        return ShadowStyle(
            name: nodeStyleName,
            description: nodeStyle.description,
            nodes: try extractShadowStyleNodes(from: nodeInfo, of: node)
        )
    }

    private func extractShadowStyleNodes(
        from nodeInfo: FigmaVectorNodeInfo,
        of node: FigmaNode
    ) throws -> [ShadowStyleNode] {
        let nodeEffects = nodeInfo.effects

        guard let nodeShadowEffects = nodeEffects?.filter({ $0.type == .dropShadow || $0.type == .innerShadow }) else {
            throw ShadowStylesProviderError(code: .shadowEffectsNotFound, nodeID: node.id, nodeName: node.name)
        }

        return try nodeShadowEffects.map {
            ShadowStyleNode(
                id: node.id,
                type: $0.rawType,
                visible: $0.isVisible,
                radius: $0.radius ?? 0.0,
                color: try extractColor(from: $0, of: node),
                blendMode: $0.rawBlendMode,
                offset: try extractVector(from: $0, of: node)
            )
        }
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

    private func extractVector(from figmaEffect: FigmaEffect, of node: FigmaNode) throws -> Vector {
        guard let effectOffset = figmaEffect.offset else {
            throw ShadowStylesProviderError(code: .offsetNotFound, nodeID: node.id, nodeName: node.name)
        }

        return Vector(x: effectOffset.x, y: effectOffset.y)
    }

    // MARK: -

    func fetchShadowStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[ShadowStyle]> {
        firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractShadowStyles(from: figmaNodes, of: figmaFile)
            }
        }
    }
}
