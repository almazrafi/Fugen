import Foundation

public struct AssetSystemColor: Codable, Hashable {

    // MARK: - Instance Properties

    public var platform: AssetSystemColorPlatform?
    public var reference: String?

    // MARK: - Initializers

    public init(platform: AssetSystemColorPlatform?, reference: String?) {
        self.platform = platform
        self.reference = reference
    }
}
