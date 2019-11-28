import Foundation

struct FigmaFrameOffset: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case nodeID = "node_id"
        case nodeOffset = "node_offset"
    }

    // MARK: - Instance Properties

    let nodeID: String
    let nodeOffset: FigmaVector
}
