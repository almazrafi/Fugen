import Foundation

struct ColorStylesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assets
    }

    // MARK: - Instance Properties

    let generatation: GenerationConfiguration
    let assets: String?

    // MARK: - Initializers

    init(
        generatation: GenerationConfiguration,
        assets: String?
    ) {
        self.generatation = generatation
        self.assets = assets
    }

    init(from decoder: Decoder) throws {
        assets = try decoder
            .container(keyedBy: CodingKeys.self)
            .decodeIfPresent(forKey: .assets)

        generatation = try GenerationConfiguration(from: decoder)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> ColorStylesConfiguration {
        return ColorStylesConfiguration(
            generatation: generatation.resolve(base: base),
            assets: assets
        )
    }
}
