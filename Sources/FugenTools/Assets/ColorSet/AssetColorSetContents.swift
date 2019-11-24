import Foundation

public struct AssetColorSetContents: Codable, Hashable {

    // MARK: - Instance Properties

    public var info: AssetInfo?
    public var colors: [AssetColor]?

    // MARK: - Initializers

    public init(
        info: AssetInfo? = AssetInfo(),
        colors: [AssetColor]? = [AssetColor()]
    ) {
        self.info = info
        self.colors = colors
    }
}
