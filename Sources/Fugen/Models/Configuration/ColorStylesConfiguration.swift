import Foundation

struct ColorStylesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assetsFolderPath
    }

    // MARK: - Instance Properties

    let generatation: GenerationConfiguration
    let assetsFolderPath: String?

    // MARK: - Initializers

    init(
        generatation: GenerationConfiguration,
        assetsFolderPath: String?
    ) {
        self.generatation = generatation
        self.assetsFolderPath = assetsFolderPath
    }

    init(from decoder: Decoder) throws {
        generatation = try GenerationConfiguration(from: decoder)

        assetsFolderPath = try decoder
            .container(keyedBy: CodingKeys.self)
            .decodeIfPresent(forKey: .assetsFolderPath)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> ColorStylesConfiguration {
        return ColorStylesConfiguration(
            generatation: generatation.resolve(base: base),
            assetsFolderPath: assetsFolderPath
        )
    }
}
