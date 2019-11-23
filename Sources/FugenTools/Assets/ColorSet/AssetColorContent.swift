import Foundation

public enum AssetColorContent: Codable, Hashable {

    // MARK: - Enumeration Cases

    case custom(AssetCustomColor)
    case system(AssetSystemColor)

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        if let color = try? AssetCustomColor(from: decoder) {
            self = .custom(color)
        } else {
            self = try .system(AssetSystemColor(from: decoder))
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        switch self {
        case let .custom(color):
            try color.encode(to: encoder)

        case let .system(color):
            try color.encode(to: encoder)
        }
    }
}
