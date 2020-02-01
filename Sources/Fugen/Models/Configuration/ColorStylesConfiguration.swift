import Foundation

struct ColorStylesConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case assets
    }

    // MARK: - Instance Properties

    let generation: GenerationConfiguration
    let assets: String?

    // MARK: - Initializers

    init(
        generation: GenerationConfiguration,
        assets: String?
    ) {
        self.generation = generation
        self.assets = assets
    }

    init(from decoder: Decoder) throws {
        assets = try decoder
            .container(keyedBy: CodingKeys.self)
            .decodeIfPresent(forKey: .assets)

        generation = try GenerationConfiguration(from: decoder)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> ColorStylesConfiguration {
        return ColorStylesConfiguration(
            generation: generation.resolve(base: base),
            assets: assets
        )
    }
}
