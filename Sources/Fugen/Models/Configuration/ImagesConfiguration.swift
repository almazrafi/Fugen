import Foundation

struct ImagesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assets
        case resources
        case format
        case scales
    }

    // MARK: - Instance Properties

    let generatation: GenerationConfiguration
    let assets: String?
    let resources: String?
    let format: ImageFormat
    let scales: [ImageScale]

    // MARK: - Initializers

    init(
        generatation: GenerationConfiguration,
        assets: String?,
        resources: String?,
        format: ImageFormat,
        scales: [ImageScale]
    ) {
        self.generatation = generatation
        self.assets = assets
        self.resources = resources
        self.format = format
        self.scales = scales
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        assets = try container.decodeIfPresent(forKey: .assets)
        resources = try container.decodeIfPresent(forKey: .resources)

        format = try container
            .decodeIfPresent(ImageRawFormat.self, forKey: .format)?
            .imageFormat ?? .pdf

        scales = try container
            .decodeIfPresent([ImageRawScale].self, forKey: .scales)?
            .map { $0.imageScale } ?? [.single]

        generatation = try GenerationConfiguration(from: decoder)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> ImagesConfiguration {
        return ImagesConfiguration(
            generatation: generatation.resolve(base: base),
            assets: assets,
            resources: resources,
            format: format,
            scales: scales
        )
    }
}

private enum ImageRawFormat: String, Codable {

    // MARK: - Enumeration Cases

    case pdf
    case png
    case jpg
    case svg

    // MARK: - Instance Properties

    var imageFormat: ImageFormat {
        switch self {
        case .pdf:
            return .pdf

        case .png:
            return .png

        case .jpg:
            return .jpg

        case .svg:
            return .svg
        }
    }
}

private enum ImageRawScale: Int, Codable {

    // MARK: - Enumeration Cases

    case scale1x = 1
    case scale2x
    case scale3x

    // MARK: - Instance Properties

    var imageScale: ImageScale {
        switch self {
        case .scale1x:
            return .scale1x

        case .scale2x:
            return .scale2x

        case .scale3x:
            return .scale3x
        }
    }
}
