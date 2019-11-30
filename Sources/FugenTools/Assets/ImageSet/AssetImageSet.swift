import Foundation

public struct AssetImageSet: AssetNode {

    // MARK: - Type Properties

    public static let pathExtension = "imageset"

    // MARK: - Instance Properties

    public var contents: AssetImageSetContents

    // MARK: - Initializers

    public init(contents: AssetImageSetContents = AssetImageSetContents()) {
        self.contents = contents
    }
}
