import Foundation

protocol FigmaNodesProvider {

    // MARK: - Instance Methods

    func fetchNodes(
        from file: FigmaFile,
        including includedNodeIDs: [String]?,
        excluding excludedNodeIDs: [String]?
    ) -> [FigmaNode]
}
