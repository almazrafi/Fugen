import Foundation

public struct AssetColorGrayscale: Codable, Hashable {

    // MARK: - Instance Properties

    public var white: String?
    public var alpha: String?

    // MARK: - Initializers

    public init(white: String? = "1.000", alpha: String? = "1.000") {
        self.white = white
        self.alpha = alpha
    }

    public init(white: Double, alpha: Double) {
        self.init(white: String(white), alpha: String(alpha))
    }

    public init(white: UInt8, alpha: UInt8) {
        self.init(white: String(white), alpha: String(Double(alpha) / 255.0))
    }
}
