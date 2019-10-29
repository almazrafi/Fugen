import Foundation

protocol NodesExtractor {

    // MARK: - Instance Methods

    func extractNodes(
        from file: FigmaFile,
        including includingNodeIDs: [String],
        excluding excludingNodeIDs: [String]
    ) -> [FigmaNode]

    func extractNode(from file: FigmaFile, with style: FigmaStyle, styleID: String) -> FigmaNode?
}
