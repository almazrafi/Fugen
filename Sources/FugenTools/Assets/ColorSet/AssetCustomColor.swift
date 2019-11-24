import Foundation

public enum AssetCustomColor: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case colorSpace = "color-space"
        case components
    }

    // MARK: - Enumeration Cases

    case sRGB(components: AssetColorComponents?)
    case extendedSRGB(components: AssetColorComponents?)
    case extendedLinearSRGB(components: AssetColorComponents?)
    case displayP3(components: AssetColorComponents?)
    case grayGamma(grayscale: AssetColorGrayscale?)
    case extendedGray(grayscale: AssetColorGrayscale?)

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(String.self, forKey: .colorSpace) {
        case .sRGBColorSpaceCodingValue:
            self = .sRGB(components: try container.decodeIfPresent(forKey: .components))

        case .extendedSRGBColorSpaceCodingValue:
            self = .extendedSRGB(components: try container.decodeIfPresent(forKey: .components))

        case .extendedLinearSRGBColorSpaceCodingValue:
            self = .extendedLinearSRGB(components: try container.decodeIfPresent(forKey: .components))

        case .displayP3ColorSpaceCodingValue:
            self = .displayP3(components: try container.decodeIfPresent(forKey: .components))

        case .grayGammaColorSpaceCodingValue:
            self = .grayGamma(grayscale: try container.decodeIfPresent(forKey: .components))

        case .extendedGrayColorSpaceCodingValue:
            self = .extendedGray(grayscale: try container.decodeIfPresent(forKey: .components))

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .colorSpace,
                in: container,
                debugDescription: "Unknown color space"
            )
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .sRGB(components):
            try container.encode(String.sRGBColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .extendedSRGB(components):
            try container.encode(String.extendedSRGBColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .extendedLinearSRGB(components):
            try container.encode(String.extendedLinearSRGBColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .displayP3(components):
            try container.encode(String.displayP3ColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .grayGamma(grayscale):
            try container.encode(String.grayGammaColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(grayscale, forKey: .components)

        case let .extendedGray(grayscale):
            try container.encode(String.extendedGrayColorSpaceCodingValue, forKey: .colorSpace)
            try container.encodeIfPresent(grayscale, forKey: .components)
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let sRGBColorSpaceCodingValue = "srgb"
    static let extendedSRGBColorSpaceCodingValue = "extended-srgb"
    static let extendedLinearSRGBColorSpaceCodingValue = "extended-linear-srgb"
    static let displayP3ColorSpaceCodingValue = "display-p3"
    static let grayGammaColorSpaceCodingValue = "gray-gamma-22"
    static let extendedGrayColorSpaceCodingValue = "extended-gray"
}
