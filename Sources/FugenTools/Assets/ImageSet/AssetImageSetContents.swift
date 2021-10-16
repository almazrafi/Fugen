import Foundation

public struct AssetImageSetContents: Codable, Hashable {

    // MARK: - Instance Properties

    public var info: AssetInfo?
    public var properties: AssetImageProperties?
    public var images: [AssetImage]?

    // MARK: - Initializers

    public init(
        info: AssetInfo? = AssetInfo(),
        properties: AssetImageProperties? = nil,
        images: [AssetImage]? = [AssetImage()]
    ) {
        self.info = info
        self.properties = properties
        self.images = images?.sorted { $0.scale?.rawValue ?? .empty <= $1.scale?.rawValue ?? .empty }
    }
}
