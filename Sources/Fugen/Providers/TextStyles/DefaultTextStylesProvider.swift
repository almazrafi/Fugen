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
            throw TextStylesProviderError.invalidTextColor(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeFillColor = nodeFill.color else {
            throw TextStylesProviderError.textColorNotFound(nodeName: node.name, nodeID: node.id)
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
            throw TextStylesProviderError.invalidFontFamily(nodeName: node.name, nodeID: node.id)
        }

        let fontName = typeStyle.fontPostScriptName ?? .textStyleRegularFontName(family: fontFamily)

        guard let fontWeight = typeStyle.fontWeight else {
            throw TextStylesProviderError.invalidFontWeight(nodeName: node.name, nodeID: node.id)
        }

        guard let fontSize = typeStyle.fontSize else {
            throw TextStylesProviderError.invalidFontSize(nodeName: node.name, nodeID: node.id)
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
            throw TextStylesProviderError.styleNotFound(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeStyleName = nodeStyle.name, !nodeStyleName.isEmpty else {
            throw TextStylesProviderError.invalidStyleName(nodeName: node.name, nodeID: node.id)
        }

        guard let nodeTypeStyle = textNodePayload.style else {
            throw TextStylesProviderError.typeStyleNotFound(nodeName: node.name, nodeID: node.id)
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

    // MARK: - TextStylesProvider

    func fetchTextStyles(
        fileKey: String,
        fileVersion: String?,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        accessToken: String
    ) -> Promise<[TextStyle]> {
        let route = FigmaAPIFileRoute(
            accessToken: accessToken,
            fileKey: fileKey,
            version: fileVersion
        )

        return firstly {
            self.apiProvider.request(route: route)
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

    static func textStyleRegularFontName(family fontFamily: String) -> String {
        return "\(fontFamily)-Regular"
    }
}
