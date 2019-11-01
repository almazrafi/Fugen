import Foundation

struct FigmaInstanceNodePayload: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case componentID = "componentId"
    }

    // MARK: - Instance Properties

    let componentID: String?
}
