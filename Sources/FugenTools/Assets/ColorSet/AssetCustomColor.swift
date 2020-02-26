import Foundation

public enum AssetCustomColor: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case colorSpace = "color-space"
        case components
    }

    private enum CodingColorSpace: String, Codable {
        case sRGB = "srgb"
        case extendedSRGB = "extended-srgb"
        case extendedLinearSRGB = "extended-linear-srgb"
        case displayP3 = "display-p3"
        case grayGamma = "gray-gamma-22"
        case extendedGray = "extended-gray"
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

        switch try container.decode(CodingColorSpace.self, forKey: .colorSpace) {
        case .sRGB:
            self = .sRGB(components: try container.decodeIfPresent(forKey: .components))

        case .extendedSRGB:
            self = .extendedSRGB(components: try container.decodeIfPresent(forKey: .components))

        case .extendedLinearSRGB:
            self = .extendedLinearSRGB(components: try container.decodeIfPresent(forKey: .components))

        case .displayP3:
            self = .displayP3(components: try container.decodeIfPresent(forKey: .components))

        case .grayGamma:
            self = .grayGamma(grayscale: try container.decodeIfPresent(forKey: .components))

        case .extendedGray:
            self = .extendedGray(grayscale: try container.decodeIfPresent(forKey: .components))
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case let .sRGB(components):
            try container.encode(CodingColorSpace.sRGB, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .extendedSRGB(components):
            try container.encode(CodingColorSpace.extendedSRGB, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .extendedLinearSRGB(components):
            try container.encode(CodingColorSpace.extendedLinearSRGB, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .displayP3(components):
            try container.encode(CodingColorSpace.displayP3, forKey: .colorSpace)
            try container.encodeIfPresent(components, forKey: .components)

        case let .grayGamma(grayscale):
            try container.encode(CodingColorSpace.grayGamma, forKey: .colorSpace)
            try container.encodeIfPresent(grayscale, forKey: .components)

        case let .extendedGray(grayscale):
            try container.encode(CodingColorSpace.extendedGray, forKey: .colorSpace)
            try container.encodeIfPresent(grayscale, forKey: .components)
        }
    }
}
