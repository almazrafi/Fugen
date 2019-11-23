import Foundation

public enum AssetAppearance: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case type = "appearance"
        case value = "value"
    }

    // MARK: - Enumeration Cases

    case luminosity(AssetAppearanceLuminosity)
    case contrast(AssetAppearanceContrast)

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .type) {
        case .luminosityAppearanceCodingValue:
            self = .luminosity(try container.decode(forKey: .value))

        case .contrastAppearanceCodingValue:
            self = .contrast(try container.decode(forKey: .value))

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .value,
                in: container,
                debugDescription: "Unknown appearance type"
            )
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .luminosity(luminosity):
            try container.encode(String.luminosityAppearanceCodingValue, forKey: .type)
            try container.encode(luminosity, forKey: .value)

        case let .contrast(contrast):
            try container.encode(String.contrastAppearanceCodingValue, forKey: .type)
            try container.encode(contrast, forKey: .value)
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let luminosityAppearanceCodingValue = "luminosity"
    static let contrastAppearanceCodingValue = "contrast"
}
