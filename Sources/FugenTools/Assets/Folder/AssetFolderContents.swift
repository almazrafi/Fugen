import Foundation

public struct AssetFolderContents: Codable, Hashable {

    // MARK: - Instance Properties

    public var info: AssetInfo?
    public var properties: AssetFolderProperties?

    // MARK: - Initializers

    public init(info: AssetInfo? = AssetInfo(), properties: AssetFolderProperties? = nil) {
        self.info = info
        self.properties = properties
    }
}
