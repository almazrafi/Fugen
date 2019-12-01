import Foundation

public struct AssetImageAlignmentInsets: Codable, Hashable {

    // MARK: - Instance Properties

    public var top: Double
    public var left: Double
    public var right: Double
    public var bottom: Double

    // MARK: - Initializers

    public init(top: Double, left: Double, right: Double, bottom: Double) {
        self.top = top
        self.left = left
        self.right = right
        self.bottom = bottom
    }
}
