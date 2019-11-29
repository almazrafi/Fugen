import Foundation

public struct AssetColorSet: AssetNode {

    // MARK: - Type Properties

    public static let pathExtension = "colorset"

    // MARK: - Instance Properties

    public var contents: AssetColorSetContents

    // MARK: - Initializers

    public init(contents: AssetColorSetContents = AssetColorSetContents()) {
        self.contents = contents
    }
}
