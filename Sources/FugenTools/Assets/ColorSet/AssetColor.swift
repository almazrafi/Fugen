import Foundation

public struct AssetColor: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case idiom
        case idiomSubtype = "subtype"
        case locale
        case appearances
        case displayGamut = "display-gamut"
        case content = "color"
    }

    // MARK: - Instance Properties

    public var content: AssetColorContent?
    public var idiom: AssetIdiom
    public var locale: String?
    public var appearances: [AssetAppearance]?
    public var displayGamut: AssetDisplayGamut?

    // MARK: - Initializers

    public init(
        content: AssetColorContent? = .custom(.sRGB(components: AssetColorComponents())),
        idiom: AssetIdiom = .universal,
        locale: String? = nil,
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil
    ) {
        self.content = content
        self.idiom = idiom
        self.locale = locale
        self.appearances = appearances
        self.displayGamut = displayGamut
    }

    public init(
        custom: AssetCustomColor,
        idiom: AssetIdiom = .universal,
        locale: String? = nil,
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil
    ) {
        self.init(
            content: .custom(custom),
            idiom: idiom,
            locale: locale,
            appearances: appearances,
            displayGamut: displayGamut
        )
    }

    public init(
        system: AssetSystemColor,
        idiom: AssetIdiom = .universal,
        locale: String? = nil,
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil
    ) {
        self.init(
            content: .system(system),
            idiom: idiom,
            locale: locale,
            appearances: appearances,
            displayGamut: displayGamut
        )
    }

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        content = try container.decodeIfPresent(forKey: .content)

        switch try container.decode(String.self, forKey: .idiom) {
        case .universalIdiomCodingValue:
            idiom = .universal

        case .iPhoneIdiomCodingValue:
            idiom = .iPhone

        case .iPadIdiomCodingValue:
            idiom = .iPad(subtype: try container.decodeIfPresent(forKey: .idiomSubtype))

        case .macIdiomCodingValue:
            idiom = .mac

        case .watchIdiomCodingValue:
            idiom = .watch

        case .tvIdiomCodingValue:
            idiom = .tv

        case .carIdiomCodingValue:
            idiom = .car

        default:
            throw DecodingError.dataCorruptedError(
                forKey: .idiom,
                in: container,
                debugDescription: "Unknown color idiom"
            )
        }

        locale = try container.decodeIfPresent(forKey: .locale)
        appearances = try container.decodeIfPresent(forKey: .appearances)
        displayGamut = try container.decodeIfPresent(forKey: .displayGamut)
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(content, forKey: .content)

        switch idiom {
        case .universal:
            try container.encode(String.universalIdiomCodingValue, forKey: .idiom)

        case .iPhone:
            try container.encode(String.iPhoneIdiomCodingValue, forKey: .idiom)

        case let .iPad(subtype):
            try container.encode(String.iPadIdiomCodingValue, forKey: .idiom)
            try container.encodeIfPresent(subtype, forKey: .idiomSubtype)

        case .mac:
            try container.encode(String.macIdiomCodingValue, forKey: .idiom)

        case .watch:
            try container.encode(String.watchIdiomCodingValue, forKey: .idiom)

        case .tv:
            try container.encode(String.tvIdiomCodingValue, forKey: .idiom)

        case .car:
            try container.encode(String.carIdiomCodingValue, forKey: .idiom)
        }

        try container.encodeIfPresent(locale, forKey: .locale)
        try container.encodeIfPresent(appearances, forKey: .appearances)
        try container.encodeIfPresent(displayGamut, forKey: .displayGamut)
    }
}

private extension String {

    // MARK: - Type Properties

    static let universalIdiomCodingValue = "universal"
    static let iPhoneIdiomCodingValue = "iphone"
    static let iPadIdiomCodingValue = "ipad"
    static let macIdiomCodingValue = "mac"
    static let watchIdiomCodingValue = "watch"
    static let tvIdiomCodingValue = "tv"
    static let carIdiomCodingValue = "car"
}
