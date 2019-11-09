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

    private func resolveNodeID(_ nodeID: String) throws -> String {
        guard let unescapedNodeID = nodeID.removingPercentEncoding else {
            throw FigmaNodesProviderError.invalidNodeID(nodeID)
        }

        return unescapedNodeID
    }

    private func resolveNodeIDs(_ nodeIDs: [String]?, defaultNodeIDs: Set<String>) throws -> Set<String> {
        guard let nodeIDs = nodeIDs else {
            return defaultNodeIDs
        }

        return try Set(nodeIDs.map { try resolveNodeID($0) })
    }

    // MARK: - FigmaNodesProvider

    func fetchNodes(
        from file: FigmaFile,
        including includedNodeIDs: [String]?,
        excluding excludedNodeIDs: [String]?
    ) throws -> [FigmaNode] {
        var includedNodeIDs = try resolveNodeIDs(includedNodeIDs, defaultNodeIDs: [file.document.id])
        var excludedNodeIDs = try resolveNodeIDs(excludedNodeIDs, defaultNodeIDs: [])

        return extractNodes(
            from: file.document,
            including: &includedNodeIDs,
            excluding: &excludedNodeIDs,
            forceInclude: false
        )
    }
}
