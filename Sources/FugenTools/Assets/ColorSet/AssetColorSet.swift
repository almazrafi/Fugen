import Foundation

public struct AssetColorSet: AssetNode {

    // MARK: - Instance Properties

    public var contents: AssetColorSetContents

    // MARK: - Initializers

    public init(contents: AssetColorSetContents = AssetColorSetContents()) {
        self.contents = contents
    }
}
