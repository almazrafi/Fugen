import Foundation

public struct AssetColor: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case content = "color"
        case appearances
        case displayGamut = "display-gamut"
        case locale
    }

    // MARK: - Instance Properties

    public var content: AssetColorContent?
    public var appearances: [AssetAppearance]?
    public var displayGamut: AssetDisplayGamut?
    public var locale: String?
    public var idiom: AssetIdiom

    // MARK: - Initializers

    public init(
        content: AssetColorContent? = .custom(.sRGB(components: AssetColorComponents())),
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil,
        locale: String? = nil,
        idiom: AssetIdiom = .universal
    ) {
        self.content = content
        self.appearances = appearances
        self.displayGamut = displayGamut
        self.locale = locale
        self.idiom = idiom
    }

    public init(
        custom: AssetCustomColor,
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil,
        locale: String? = nil,
        idiom: AssetIdiom = .universal
    ) {
        self.init(
            content: .custom(custom),
            appearances: appearances,
            displayGamut: displayGamut,
            locale: locale,
            idiom: idiom
        )
    }

    public init(
        system: AssetSystemColor,
        appearances: [AssetAppearance]? = nil,
        displayGamut: AssetDisplayGamut? = nil,
        locale: String? = nil,
        idiom: AssetIdiom = .universal
    ) {
        self.init(
            content: .system(system),
            appearances: appearances,
            displayGamut: displayGamut,
            locale: locale,
            idiom: idiom
        )
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        content = try container.decodeIfPresent(forKey: .content)
        appearances = try container.decodeIfPresent(forKey: .appearances)
        displayGamut = try container.decodeIfPresent(forKey: .displayGamut)
        locale = try container.decodeIfPresent(forKey: .locale)

        idiom = try AssetIdiom(from: decoder)
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(content, forKey: .content)
        try container.encodeIfPresent(appearances, forKey: .appearances)
        try container.encodeIfPresent(displayGamut, forKey: .displayGamut)
        try container.encodeIfPresent(locale, forKey: .locale)

        try idiom.encode(to: encoder)
    }
}
