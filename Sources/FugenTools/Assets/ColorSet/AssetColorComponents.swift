import Foundation

public struct AssetColorComponents: Codable, Hashable {

    // MARK: - Instance Properties

    public var red: String?
    public var green: String?
    public var blue: String?
    public var alpha: String?

    // MARK: - Initializers

    public init(
        red: String? = "1.000",
        green: String? = "1.000",
        blue: String? = "1.000",
        alpha: String? = "1.000"
    ) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        self.init(
            red: String(red),
            green: String(green),
            blue: String(blue),
            alpha: String(alpha)
        )
    }

    public init(red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(
            red: String(red),
            green: String(green),
            blue: String(blue),
            alpha: String(Double(alpha) / 255.0)
        )
    }
}
