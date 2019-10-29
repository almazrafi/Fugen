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

    private func extractColor(from node: FigmaNode) -> FigmaColor? {
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

        case let .vector(info: nodeInfo),
             let .star(info: nodeInfo),
             let .line(info: nodeInfo),
             let .ellipse(info: nodeInfo),
             let .regularPolygon(info: nodeInfo),
             let .rectangle(info: nodeInfo, payload: _),
             let .text(info: nodeInfo, payload: _):
            return nodeInfo.fills?
                .lazy
                .filter { $0.type == .solid }
                .compactMap { $0.color }
                .lazyFirst
        }
    }

    private func extractColors(
        from file: FigmaFile,
        excludingNodes excludingNodeIDs: [String],
        includingNodes includingNodeIDs: [String]
    ) throws -> [Color] {
        guard let styles = file.styles else {
            throw ColorsError.stylesNotFound
        }

        let filteringNodes = nodesExtractor.extractNodes(
            from: file,
            including: includingNodeIDs,
            excluding: excludingNodeIDs
        )

        return try styles
            .lazy
            .filter { $0.value.type == .fill }
            .compactMap { styleID, style in
                guard let node = nodesExtractor.extractNode(from: file, with: style, styleID: styleID) else {
                    throw ColorsError.invalidStyle(styleID: styleID)
                }

                guard filteringNodes.contains(node) else {
                    return nil
                }

                guard let color = extractColor(from: node) else {
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
