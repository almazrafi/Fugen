import Foundation

struct FigmaBooleanOperationNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case children
        case rawOperationType = "booleanOperation"
    }

    // MARK: - Instance Properties

    let children: [FigmaNode]?
    let rawOperationType: String?

    var operationType: FigmaBooleanOperationType? {
        rawOperationType.flatMap(FigmaBooleanOperationType.init)
    }
}
