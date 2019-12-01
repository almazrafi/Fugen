import Foundation

public struct AssetImage: Codable, Hashable {

    // MARK: - Enumeration Cases

    private enum CodingKeys: String, CodingKey {
        case fileName = "filename"
        case scale
        case appearances
        case widthClass = "width-class"
        case heightClass = "height-class"
        case alignmentInsets = "alignment-insets"
        case graphicsFeatureSet = "graphics-feature-set"
        case memory = "memory"
        case compressionType = "compression-type"
        case languageDirection = "language-direction"
        case displayGamut = "display-gamut"
        case locale
    }

    // MARK: - Instance Properties

    public var fileName: String?
    public var scale: AssetImageScale?
    public var appearances: [AssetAppearance]?
    public var widthClass: AssetImageSizeClass?
    public var heightClass: AssetImageSizeClass?
    public var alignmentInsets: AssetImageAlignmentInsets?
    public var graphicsFeatureSet: AssetImageGraphicsFeatureSet?
    public var memory: AssetImageMemory?
    public var compressionType: AssetCompressionType?
    public var languageDirection: AssetImageLanguageDirection?
    public var displayGamut: AssetDisplayGamut?
    public var locale: String?
    public var idiom: AssetIdiom

    // MARK: - Initializers

    public init(
        fileName: String? = nil,
        scale: AssetImageScale? = nil,
        appearances: [AssetAppearance]? = nil,
        widthClass: AssetImageSizeClass? = nil,
        heightClass: AssetImageSizeClass? = nil,
        alignmentInsets: AssetImageAlignmentInsets? = nil,
        graphicsFeatureSet: AssetImageGraphicsFeatureSet? = nil,
        memory: AssetImageMemory? = nil,
        compressionType: AssetCompressionType? = nil,
        languageDirection: AssetImageLanguageDirection? = nil,
        displayGamut: AssetDisplayGamut? = nil,
        locale: String? = nil,
        idiom: AssetIdiom = .universal
    ) {
        self.fileName = fileName
        self.scale = scale
        self.appearances = appearances
        self.widthClass = widthClass
        self.heightClass = heightClass
        self.alignmentInsets = alignmentInsets
        self.graphicsFeatureSet = graphicsFeatureSet
        self.memory = memory
        self.compressionType = compressionType
        self.languageDirection = languageDirection
        self.displayGamut = displayGamut
        self.locale = locale
        self.idiom = idiom
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        fileName = try container.decodeIfPresent(forKey: .fileName)
        scale = try container.decodeIfPresent(forKey: .scale)
        appearances = try container.decodeIfPresent(forKey: .appearances)
        widthClass = try container.decodeIfPresent(forKey: .widthClass)
        heightClass = try container.decodeIfPresent(forKey: .heightClass)
        alignmentInsets = try container.decodeIfPresent(forKey: .alignmentInsets)
        graphicsFeatureSet = try container.decodeIfPresent(forKey: .graphicsFeatureSet)
        memory = try container.decodeIfPresent(forKey: .memory)
        compressionType = try container.decodeIfPresent(forKey: .compressionType)
        languageDirection = try container.decodeIfPresent(forKey: .languageDirection)
        displayGamut = try container.decodeIfPresent(forKey: .displayGamut)
        locale = try container.decodeIfPresent(forKey: .locale)

        idiom = try AssetIdiom(from: decoder)
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encodeIfPresent(fileName, forKey: .fileName)
        try container.encodeIfPresent(scale, forKey: .scale)
        try container.encodeIfPresent(appearances, forKey: .appearances)
        try container.encodeIfPresent(widthClass, forKey: .widthClass)
        try container.encodeIfPresent(heightClass, forKey: .heightClass)
        try container.encodeIfPresent(alignmentInsets, forKey: .alignmentInsets)
        try container.encodeIfPresent(graphicsFeatureSet, forKey: .graphicsFeatureSet)
        try container.encodeIfPresent(memory, forKey: .memory)
        try container.encodeIfPresent(compressionType, forKey: .compressionType)
        try container.encodeIfPresent(languageDirection, forKey: .languageDirection)
        try container.encodeIfPresent(displayGamut, forKey: .displayGamut)
        try container.encodeIfPresent(locale, forKey: .locale)

        try idiom.encode(to: encoder)
    }
}
