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

    private func extractColorStyle(
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
        let nodeFills = nodeInfo.fills

        guard nodeFills?.count == 1, let nodeFill = nodeFills?.first(where: { $0.type == .solid }) else {
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
            weight: fontWeight,
            size: fontSize
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

        return TextStyle(
            name: nodeStyleName,
            font: try extractFont(from: nodeTypeStyle, of: node),
            colorStyle: try extractColorStyle(from: nodeInfo, of: node, styles: styles),
            color: try extractColor(from: nodeInfo, of: node),
            strikethrough: nodeTypeStyle.textDecoration == .strikethrough,
            underline: nodeTypeStyle.textDecoration == .underline,
            paragraphSpacing: nodeTypeStyle.paragraphSpacing,
            paragraphIndent: nodeTypeStyle.paragraphIndent,
            lineHeight: nodeTypeStyle.lineHeight,
            letterSpacing: nodeTypeStyle.letterSpacing
        )
    }

    private func extractTextStyles(
        from file: FigmaFile,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?
    ) throws -> [TextStyle] {
        return try nodesProvider
            .fetchNodes(from: file, including: includedNodeIDs, excluding: excludedNodeIDs)
            .lazy
            .compactMap { try extractTextStyle(from: $0, styles: file.styles ?? [:]) }
            .reduce(into: []) { result, textStyle in
                if !result.contains(textStyle) {
                    result.append(textStyle)
                }
            }
    }

    // MARK: -

    func fetchTextStyles(
        fileKey: String,
        fileVersion: String?,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[TextStyle]> {
        return firstly {
            self.filesProvider.fetchFile(key: fileKey, version: fileVersion, accessToken: accessToken)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractTextStyles(
                from: file,
                includingNodes: includedNodeIDs,
                excludingNodes: excludedNodeIDs
            )
        }
    }
}

private extension String {

    // MARK: - Type Methods

    static func regularFontName(family fontFamily: String) -> String {
        return "\(fontFamily)-Regular"
    }
}
