import Foundation
import PromiseKit

final class DefaultColorsProvider: ColorsProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider
    let nodesExtractor: NodesExtractor

    // MARK: - Initializers

    init(
        apiProvider: FigmaAPIProvider,
        nodesExtractor: NodesExtractor
    ) {
        self.apiProvider = apiProvider
        self.nodesExtractor = nodesExtractor
    }

    // MARK: - Instance Methods

    private func extractColor(from nodeInfo: FigmaVectorNodeInfo, styleID: String) -> FigmaColor? {
        let style = nodeInfo.styles?
            .lazy
            .filter { FigmaStyleType(rawValue: $0.key.uppercased()) == .fill }
            .filter { $0.value == styleID }
            .lazyFirst

        guard style != nil else {
            return nil
        }

        return nodeInfo.fills?
            .lazy
            .filter { $0.type == .solid }
            .compactMap { $0.color }
            .lazyFirst
    }

    private func extractColor(from node: FigmaNode, styleID: String) -> FigmaColor? {
        switch node.type {
        case .unknown,
             .document,
             .canvas,
             .frame,
             .group,
             .booleanOperation,
             .slice,
             .component,
             .instance:
            return nil

        case let .vector(info: vectorNodeInfo),
             let .star(info: vectorNodeInfo),
             let .line(info: vectorNodeInfo),
             let .ellipse(info: vectorNodeInfo),
             let .regularPolygon(info: vectorNodeInfo),
             let .rectangle(info: vectorNodeInfo, payload: _),
             let .text(info: vectorNodeInfo, payload: _):
            return extractColor(from: vectorNodeInfo, styleID: styleID)
        }
    }

    private func extractColor(from nodes: [FigmaNode], styleID: String) -> FigmaColor? {
        return nodes
            .lazy
            .compactMap { self.extractColor(from: $0, styleID: styleID) }
            .lazyFirst
    }

    private func extractColors(
        from file: FigmaFile,
        excludingNodes excludingNodeIDs: [String],
        includingNodes includingNodeIDs: [String]
    ) throws -> [Color] {
        guard let styles = file.styles else {
            throw ColorsError.stylesNotFound
        }

        let nodes = try nodesExtractor.extractNodes(
            from: file,
            excluding: excludingNodeIDs,
            including: includingNodeIDs
        )

        return try styles
            .filter { $0.value.type == .fill }
            .map { styleID, style in
                guard let color = extractColor(from: nodes, styleID: styleID) else {
                    throw ColorsError.invalidStyle(styleID: styleID)
                }

                return Color(
                    name: style.name,
                    red: color.red,
                    green: color.green,
                    blue: color.blue,
                    alpha: color.alpha
                )
            }
    }

    // MARK: - ColorsProvider

    func fetchColors(
        fileKey: String,
        excludingNodes excludingNodeIDs: [String],
        includingNodes includingNodeIDs: [String]
    ) -> Promise<[Color]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractColors(
                from: file,
                excludingNodes: excludingNodeIDs,
                includingNodes: includingNodeIDs
            )
        }
    }
}
