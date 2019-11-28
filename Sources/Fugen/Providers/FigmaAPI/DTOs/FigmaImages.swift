import Foundation

struct FigmaImages: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case error = "err"
        case urls = "images"
    }

    // MARK: - Instance Properties

    let error: String?
    let urls: [String: String?]
}
