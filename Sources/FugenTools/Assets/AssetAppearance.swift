import Foundation

public enum AssetAppearance: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case type = "appearance"
        case value = "value"
    }

    private enum CodingType: String, Codable {
        case luminosity
        case contrast
    }

    // MARK: - Enumeration Cases

    case luminosity(AssetAppearanceLuminosity)
    case contrast(AssetAppearanceContrast)

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(CodingType.self, forKey: .type) {
        case .luminosity:
            self = .luminosity(try container.decode(forKey: .value))

        case .contrast:
            self = .contrast(try container.decode(forKey: .value))
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .luminosity(luminosity):
            try container.encode(CodingType.luminosity, forKey: .type)
            try container.encode(luminosity, forKey: .value)

        case let .contrast(contrast):
            try container.encode(CodingType.contrast, forKey: .type)
            try container.encode(contrast, forKey: .value)
        }
    }
}
