import Foundation
import PromiseKit

final class DefaultTextStylesProvider: TextStylesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(filesProvider: FigmaFilesProvider, nodesProvider: FigmaNodesProvider) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractColorStyleName(
        from nodeInfo: FigmaVectorNodeInfo,
        of node: FigmaNode,
        styles: [String: FigmaStyle]
    ) throws -> String? {
        guard let nodeStyleID = nodeInfo.styleID(of: .fill) else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .fill else {
            throw TextStylesProviderError(code: .colorStyleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw TextStylesProviderError(code: .invalidColorStyleName, nodeID: node.id, nodeName: node.name)
        }

        return nodeStyleName
    }

    private func extractColor(from nodeInfo: FigmaVectorNodeInfo, of node: FigmaNode) throws -> Color {
        let nodeFills = nodeInfo.fills?.filter { nodeFill in
            (nodeFill.isVisible ?? true) && (nodeFill.type == .solid)
        } ?? []

        guard let nodeFill = nodeFills.first, nodeFills.count == 1 else {
            throw TextStylesProviderError(code: .invalidColor, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeFillColor = nodeFill.color else {
            throw TextStylesProviderError(code: .colorNotFound, nodeID: node.id, nodeName: node.name)
        }

        return Color(
            red: nodeFillColor.red,
            green: nodeFillColor.green,
            blue: nodeFillColor.blue,
            alpha: nodeFillColor.alpha
        )
    }

    private func extractFont(from typeStyle: FigmaTypeStyle, of node: FigmaNode) throws -> Font {
        guard let fontFamily = typeStyle.fontFamily, !fontFamily.isEmpty else {
            throw TextStylesProviderError(code: .invalidFontFamily, nodeID: node.id, nodeName: node.name)
        }

        let fontName = typeStyle.fontPostScriptName ?? .regularFontName(family: fontFamily)

        guard let fontWeight = typeStyle.fontWeight else {
            throw TextStylesProviderError(code: .invalidFontWeight, nodeID: node.id, nodeName: node.name)
        }

        guard let fontSize = typeStyle.fontSize else {
            throw TextStylesProviderError(code: .invalidFontSize, nodeID: node.id, nodeName: node.name)
        }

        return Font(
            family: fontFamily,
            name: fontName,
            weight: fontWeight.rounded(precision: 1),
            size: fontSize.rounded(precision: 1)
        )
    }

    private func extractTextStyle(from node: FigmaNode, styles: [String: FigmaStyle]) throws -> TextStyle? {
        guard case let .text(info: nodeInfo, payload: textNodePayload) = node.type else {
            return nil
        }

        guard let nodeStyleID = nodeInfo.styleID(of: .text) else {
            return nil
        }

        guard let nodeStyle = styles[nodeStyleID], nodeStyle.type == .text else {
            throw TextStylesProviderError(code: .styleNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw TextStylesProviderError(code: .invalidStyleName, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeTypeStyle = textNodePayload.style else {
            throw TextStylesProviderError(code: .typeStyleNotFound, nodeID: node.id, nodeName: node.name)
        }

        let textStyleNode = TextStyleNode(
            name: nodeStyleName,
            description: nodeStyle.description,
            font: try extractFont(from: nodeTypeStyle, of: node),
            strikethrough: nodeTypeStyle.textDecoration == .strikethrough,
            underline: nodeTypeStyle.textDecoration == .underline,
            paragraphSpacing: nodeTypeStyle.paragraphSpacing?.rounded(precision: 4),
            paragraphIndent: nodeTypeStyle.paragraphIndent?.rounded(precision: 4),
            lineHeight: nodeTypeStyle.lineHeight?.rounded(precision: 4),
            letterSpacing: nodeTypeStyle.letterSpacing?.rounded(precision: 4)
        )

        let textStyleColor = TextStyleColor(
            styleName: try extractColorStyleName(from: nodeInfo, of: node, styles: styles),
            color: try extractColor(from: nodeInfo, of: node)
        )

        return TextStyle(node: textStyleNode, color: textStyleColor)
    }

    private func extractTextStyles(from nodes: [FigmaNode], of file: FigmaFile) throws -> [TextStyle] {
        let styles = file.styles ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
            .compactMap { try extractTextStyle(from: $0, styles: styles) }
            .reduce(into: []) { result, textStyle in
                if !result.contains(where: { $0.node == textStyle.node }) {
                    result.append(textStyle)
                }
            }
    }

    // MARK: -

    func fetchTextStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[TextStyle]> {
        return firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractTextStyles(from: figmaNodes, of: figmaFile)
            }
        }
    }
}

private extension String {

    // MARK: - Type Methods

    static func regularFontName(family fontFamily: String) -> String {
        return "\(fontFamily)-Regular"
    }
}
