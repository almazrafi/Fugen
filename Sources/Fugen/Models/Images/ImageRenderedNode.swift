import Foundation

struct ImageRenderedNode: Encodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case urls
    }

    // MARK: - Instance Properties

    let base: ImageNode
    let urls: [ImageScale: URL]

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try base.encode(to: encoder)
        try urls.encode(to: encoder, forKey: CodingKeys.urls)
    }
}
