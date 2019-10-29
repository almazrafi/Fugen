import Foundation

final class DefaultNodesExtractor: NodesExtractor {

    // MARK: - Instance Methods

    private func extractNodes(
        from node: FigmaNode,
        including includingNodeIDs: inout Set<String>,
        excluding excludingNodeIDs: inout Set<String>,
        forceInclude: Bool
    ) -> [FigmaNode] {
        let isIncludingNode = includingNodeIDs.remove(node.id) != nil
        let isExcludingNode = excludingNodeIDs.remove(node.id) != nil

        var nodes: [FigmaNode] = []

        guard !isExcludingNode else {
            return []
        }

        if isIncludingNode || forceInclude {
            nodes.append(node)
        }

        let children: [FigmaNode]?

        switch node.type {
        case .unknown, .slice, .vector, .star, .line, .ellipse, .regularPolygon, .rectangle, .text:
            return nodes

        case let .booleanOperation(info: _, payload: payload):
            children = payload.children

        case let .document(info: documentNodeInfo):
            children = documentNodeInfo.children

        case let .canvas(info: canvasNodeInfo):
            children = canvasNodeInfo.children

        case let .frame(info: frameNodeInfo),
             let .group(info: frameNodeInfo),
             let .component(info: frameNodeInfo),
             let .instance(info: frameNodeInfo, payload: _):
            children = frameNodeInfo.children
        }

        let filteredChildren = children?.flatMap { child in
            return extractNodes(
                from: child,
                including: &includingNodeIDs,
                excluding: &excludingNodeIDs,
                forceInclude: forceInclude || isIncludingNode
            )
        } ?? []

        return nodes.appending(contentsOf: filteredChildren)
    }

    private func extractNode(from node: FigmaNode, with style: FigmaStyle, styleID: String) -> FigmaNode? {
        let children: [FigmaNode]?

        switch node.type {
        case .unknown, .booleanOperation, .slice:
            return nil

        case let .vector(info: nodeInfo),
             let .star(info: nodeInfo),
             let .line(info: nodeInfo),
             let .ellipse(info: nodeInfo),
             let .regularPolygon(info: nodeInfo),
             let .rectangle(info: nodeInfo, payload: _),
             let .text(info: nodeInfo, payload: _):
            let hasStyle = nodeInfo.styles?
                .lazy
                .filter { FigmaStyleType(rawValue: $0.key.uppercased()) == style.type }
                .filter { $0.value == styleID }
                .lazyFirst != nil

            return hasStyle ? node : nil

        case let .document(info: documentNodeInfo):
            children = documentNodeInfo.children

        case let .canvas(info: canvasNodeInfo):
            children = canvasNodeInfo.children

        case let .frame(info: frameNodeInfo),
             let .group(info: frameNodeInfo),
             let .component(info: frameNodeInfo),
             let .instance(info: frameNodeInfo, payload: _):
            children = frameNodeInfo.children
        }

        return children?
            .lazy
            .compactMap { self.extractNode(from: $0, with: style, styleID: styleID) }
            .lazyFirst
    }

    // MARK: - NodesExtractor

    func extractNodes(
        from file: FigmaFile,
        including includingNodeIDs: [String],
        excluding excludingNodeIDs: [String]
    ) -> [FigmaNode] {
        var includingNodeIDs = Set(includingNodeIDs)
        var excludingNodeIDs = Set(excludingNodeIDs)

        if includingNodeIDs.isEmpty {
            includingNodeIDs.insert(file.document.id)
        }

        return extractNodes(
            from: file.document,
            including: &includingNodeIDs,
            excluding: &excludingNodeIDs,
            forceInclude: false
        )
    }

    func extractNode(from file: FigmaFile, with style: FigmaStyle, styleID: String) -> FigmaNode? {
        return extractNode(from: file.document, with: style, styleID: styleID)
    }
}
