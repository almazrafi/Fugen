import Foundation

protocol NodesExtractor {

    // MARK: - Instance Methods

    func extractNodes(
        from file: FigmaFile,
        excluding excludingNodeIDs: [String],
        including includingNodeIDs: [String]
    ) throws -> [FigmaNode]
}
