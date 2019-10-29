import Foundation

protocol NodesExtractor {

    // MARK: - Instance Methods

    func extractNodes(
        from file: FigmaFile,
        excluding excludingNodeIDs: [String],
        including includingNodeIDs: [String]
    ) -> [FigmaNode]

    func extractNode(from file: FigmaFile, with style: FigmaStyle, styleID: String) -> FigmaNode?
}
