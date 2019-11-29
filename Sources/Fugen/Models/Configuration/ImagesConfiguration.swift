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
        generatation = try GenerationConfiguration(from: decoder)

        let container = try decoder.container(keyedBy: CodingKeys.self)

        assets = try container.decodeIfPresent(forKey: .assets)
        resources = try container.decodeIfPresent(forKey: .resources)

        switch try container.decodeIfPresent(ImageRawFormat.self, forKey: .format) {
        case .pdf, nil:
            format = .pdf

        case .png:
            format = .png

        case .jpg:
            format = .jpg

        case .svg:
            format = .svg
        }

        if let rawScales = try container.decodeIfPresent([ImageRawScale].self, forKey: .scales) {
            scales = rawScales.map { rawScale in
                switch rawScale {
                case .scale1x:
                    return .scale1x

                case .scale2x:
                    return .scale2x

                case .scale3x:
                    return .scale3x

                case .scale4x:
                    return .scale4x
                }
            }
        } else {
            scales = [.single]
        }
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
}

private enum ImageRawScale: Int, Codable {

    // MARK: - Enumeration Cases

    case scale1x = 1
    case scale2x
    case scale3x
    case scale4x
}
