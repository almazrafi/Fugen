import Foundation
import PromiseKit

final class DefaultTextStylesProvider: TextStylesProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(
        apiProvider: FigmaAPIProvider,
        nodesProvider: FigmaNodesProvider
    ) {
        self.apiProvider = apiProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractColor(from nodeInfo: FigmaVectorNodeInfo, of node: FigmaNode) throws -> Color {
        let nodeFills = nodeInfo.fills

        guard nodeFills?.count == 1, let nodeFill = nodeFills?.first(where: { $0.type == .solid }) else {
            throw TextStylesError.invalidTextColor(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeFillColor = nodeFill.color else {
            throw TextStylesError.textColorNotFound(nodeName: node.name, nodeID: node.id)
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
            throw TextStylesError.invalidFontFamily(nodeName: node.name, nodeID: node.id)
        }

        guard let fontName = typeStyle.fontPostScriptName, !fontName.isEmpty else {
            throw TextStylesError.invalidFontPostScriptName(nodeName: node.name, nodeID: node.id)
        }

        guard let fontWeight = typeStyle.fontWeight else {
            throw TextStylesError.invalidFontWeight(nodeName: node.name, nodeID: node.id)
        }

        guard let fontSize = typeStyle.fontSize else {
            throw TextStylesError.invalidFontSize(nodeName: node.name, nodeID: node.id)
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
            throw TextStylesError.styleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw TextStylesError.invalidStyleName(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeTypeStyle = textNodePayload.style else {
            throw TextStylesError.typeStyleNotFound(nodeName: node.name, nodeID: node.id)
        }

        return TextStyle(
            name: nodeStyleName,
            font: try extractFont(from: nodeTypeStyle, of: node),
            textColor: try extractColor(from: nodeInfo, of: node),
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
        includingNodes includingNodeIDs: [String],
        excludingNodes excludingNodeIDs: [String]
    ) throws -> [TextStyle] {
        return try nodesProvider
            .extractNodes(from: file, including: includingNodeIDs, excluding: excludingNodeIDs)
            .lazy
            .compactMap { try extractTextStyle(from: $0, styles: file.styles ?? [:]) }
            .reduce(into: []) { result, textStyle in
                if !result.contains(textStyle) {
                    result.append(textStyle)
                }
            }
    }

    // MARK: - Instance Methods

    func fetchTextStyles(
        fileKey: String,
        accessToken: String,
        includingNodes includingNodeIDs: [String],
        excludingNodes excludingNodeIDs: [String]
    ) -> Promise<[TextStyle]> {
        return firstly {
            self.apiProvider.request(route: FigmaAPIFileRoute(fileKey: fileKey, accessToken: accessToken))
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractTextStyles(
                from: file,
                includingNodes: includingNodeIDs,
                excludingNodes: excludingNodeIDs
            )
        }
    }
}
