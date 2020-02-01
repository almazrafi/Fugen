import Foundation

struct Image: Encodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case format
        case asset
        case resource
    }

    // MARK: - Instance Properties

    let node: ImageRenderedNode
    let format: ImageFormat
    let asset: ImageAsset?
    let resource: ImageResource?

    // MARK: - Instance Methods

    func encode(to encoder: Encoder) throws {
        try node.encode(to: encoder)
        try format.encode(to: encoder, forKey: CodingKeys.format)
        try asset.encode(to: encoder, forKey: CodingKeys.asset)
        try resource.encode(to: encoder, forKey: CodingKeys.resource)
    }
}
