import Foundation

final class DefaultFigmaNodesProvider: FigmaNodesProvider {

    // MARK: - Instance Methods

    private func extractNodes(
        from node: FigmaNode,
        including includedNodeIDs: inout Set<String>,
        excluding excludedNodeIDs: inout Set<String>,
        forceInclude: Bool
    ) -> [FigmaNode] {
        let isIncludedNode = includedNodeIDs.remove(node.id) != nil
        let isExcludedNode = excludedNodeIDs.remove(node.id) != nil

        var nodes: [FigmaNode] = []

        guard !isExcludedNode else {
            return nodes
        }

        if isIncludedNode || forceInclude {
            nodes.append(node)
        }

        guard let children = node.children, !children.isEmpty else {
            return nodes
        }

        return children
            .flatMap { child in
                extractNodes(
                    from: child,
                    including: &includedNodeIDs,
                    excluding: &excludedNodeIDs,
                    forceInclude: forceInclude || isIncludedNode
                )
            }
            .prepending(contentsOf: nodes)
    }

    // MARK: - FigmaNodesProvider

    func fetchNodes(
        from file: FigmaFile,
        including includedNodeIDs: [String]?,
        excluding excludedNodeIDs: [String]?
    ) -> [FigmaNode] {
        var includedNodeIDs = Set(includedNodeIDs ?? [])
        var excludedNodeIDs = Set(excludedNodeIDs ?? [])

        if includedNodeIDs.isEmpty {
            includedNodeIDs.insert(file.document.id)
        }

        return extractNodes(
            from: file.document,
            including: &includedNodeIDs,
            excluding: &excludedNodeIDs,
            forceInclude: false
        )
    }
}
