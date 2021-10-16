import PromiseKit

final class DefaultGradientStylesProvider: GradientStylesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(filesProvider: FigmaFilesProvider, nodesProvider: FigmaNodesProvider) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractGradientStyleNode(
        from node: FigmaNode,
        styles: [String: FigmaStyle]
    ) throws -> GradientStyleNode? {
        guard let nodeInfo = node.vectorInfo, let nodeStyleID = nodeInfo.styleID(of: .fill) else {
            return nil
        }

        let nodeFills = nodeInfo.fills?.filter { nodeFill in
            (nodeFill.isVisible ?? true)
                && (nodeFill.type == .gradientLinear
                        || nodeFill.type == .gradientRadial
                        || nodeFill.type == .gradientAngular)
        } ?? []

        guard let nodeFill = nodeFills.first, nodeFills.count == 1 else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .fill else {
            throw GradientStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw GradientStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
        }

        guard let gradientType = nodeFill.type?.gradientType else {
            throw GradientStylesProviderError(code: .gradientTypeNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let gradientStops = nodeFill.gradientStops else {
            throw GradientStylesProviderError(code: .gradientStopsNotFound, nodeID: node.id, nodeName: node.name)
        }

        return GradientStyleNode(
            name: nodeStyleName,
            description: nodeStyle.description,
            gradientType: gradientType,
            gradientStops: gradientStops.map { gradientStop in
                ColorStop(
                    color: Color(
                        red: gradientStop.color.red,
                        green: gradientStop.color.green,
                        blue: gradientStop.color.blue,
                        alpha: gradientStop.color.alpha
                    ),
                    position: gradientStop.position
                )
            }
        )
    }

    private func extractGradientStyleNodes(from nodes: [FigmaNode], of file: FigmaFile) throws -> [GradientStyleNode] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
            .compactMap { try extractGradientStyleNode(from: $0, styles: styles) }
            .reduce(into: [], { result, node in
                if !result.contains(node) {
                    result.append(node)
                }
            })
    }

    // MARK: -

    func fetchGradientStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[GradientStyle]> {
        firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { ($0, figmaFile) }
        }.map { figmaNodes, figmaFile in
            try self.extractGradientStyleNodes(from: figmaNodes, of: figmaFile)
        }.map { nodes in
            nodes.map { GradientStyle(node: $0) }
        }
    }
}

// MARK: -

private extension FigmaPaintType {

    // MARK: - Instance Properties

    var gradientType: GradientType? {
        switch self {
        case .gradientLinear:
            return .axial

        case .gradientRadial:
            return .radical

        case .gradientAngular:
            return .conic

        case .emoji, .gradientDiamond, .image, .solid:
            return nil
        }
    }
}
