import Foundation

struct ImagesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assets
        case resources
        case format
        case scales
        case onlyExportables
        case useAbsoluteBounds
        case preserveVectorData
    }

    // MARK: - Instance Properties

    let generatation: GenerationConfiguration
    let assets: String?
    let resources: String?
    let format: ImageFormat
    let scales: [ImageScale]
    let onlyExportables: Bool
    let useAbsoluteBounds: Bool
    let preserveVectorData: Bool

    // MARK: - Initializers

    init(
        generatation: GenerationConfiguration,
        assets: String?,
        resources: String?,
        format: ImageFormat,
        scales: [ImageScale],
        onlyExportables: Bool,
        useAbsoluteBounds: Bool,
        preserveVectorData: Bool
    ) {
        self.generatation = generatation
        self.assets = assets
        self.resources = resources
        self.format = format
        self.scales = scales
        self.onlyExportables = onlyExportables
        self.useAbsoluteBounds = useAbsoluteBounds
        self.preserveVectorData = preserveVectorData
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        assets = try container.decodeIfPresent(forKey: .assets)
        resources = try container.decodeIfPresent(forKey: .resources)

        format = try container.decodeIfPresent(forKey: .format) ?? .pdf
        scales = try container.decodeIfPresent(forKey: .scales) ?? [.none]
        onlyExportables = try container.decodeIfPresent(forKey: .onlyExportables) ?? false
        useAbsoluteBounds = try container.decodeIfPresent(forKey: .useAbsoluteBounds) ?? false
        preserveVectorData = try container.decodeIfPresent(forKey: .preserveVectorData) ?? false

        generatation = try GenerationConfiguration(from: decoder)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> ImagesConfiguration {
        return ImagesConfiguration(
            generatation: generatation.resolve(base: base),
            assets: assets,
            resources: resources,
            format: format,
            scales: scales,
            onlyExportables: onlyExportables,
            useAbsoluteBounds: useAbsoluteBounds,
            preserveVectorData: preserveVectorData
        )
    }
}
