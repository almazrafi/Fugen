import Foundation

public struct AnyCodingKey: CodingKey {

    // MARK: - Instance Properties

    public let stringValue: String
    public let intValue: Int?

    // MARK: - Initializers

    public init(_ stringValue: String) {
        self.stringValue = stringValue
        self.intValue = nil
    }

    public init(_ intValue: Int) {
        self.stringValue = "\(intValue)"
        self.intValue = intValue
    }

    public init?(stringValue: String) {
        self.init(stringValue)
    }

    public init?(intValue: Int) {
        self.init(intValue)
    }
}
