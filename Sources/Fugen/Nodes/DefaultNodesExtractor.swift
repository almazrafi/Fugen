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
            return nodes
        }

        if isIncludingNode || forceInclude {
            nodes.append(node)
        }

        guard let children = node.children, !children.isEmpty else {
            return nodes
        }

        return children
            .flatMap { child in
                extractNodes(
                    from: child,
                    including: &includingNodeIDs,
                    excluding: &excludingNodeIDs,
                    forceInclude: forceInclude || isIncludingNode
                )
            }
            .prepending(contentsOf: nodes)
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
}
