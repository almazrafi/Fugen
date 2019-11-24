import Foundation

public struct AssetFolderProperties: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case compressionType = "compression-type"
        case providesNamespace = "provides-namespace"
        case onDemandResourceTags = "on-demand-resource-tags"
    }

    // MARK: - Instance Properties

    public var compressionType: AssetCompressionType?
    public var providesNamespace: Bool?
    public var onDemandResourceTags: [String]?

    // MARK: - Initializers

    public init(
        compressionType: AssetCompressionType? = nil,
        providesNamespace: Bool? = nil,
        onDemandResourceTags: [String]? = nil
    ) {
        self.compressionType = compressionType
        self.providesNamespace = providesNamespace
        self.onDemandResourceTags = onDemandResourceTags
    }
}
