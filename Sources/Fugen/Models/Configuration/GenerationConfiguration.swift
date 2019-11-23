import Foundation
import FugenTools

struct GenerationConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
        case templatePath
        case templateOptions
        case destinationPath
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: String?
    let templatePath: String?
    let templateOptions: [String: Any]?
    let destinationPath: String?

    // MARK: - Initializers

    init(
        file: FileConfiguration?,
        accessToken: String?,
        templatePath: String?,
        templateOptions: [String: Any]?,
        destinationPath: String?
    ) {
        self.file = file
        self.accessToken = accessToken
        self.templatePath = templatePath
        self.templateOptions = templateOptions
        self.destinationPath = destinationPath
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        file = try container.decodeIfPresent(forKey: .file)
        accessToken = try container.decodeIfPresent(forKey: .accessToken)
        templatePath = try container.decodeIfPresent(forKey: .templatePath)

        templateOptions = try container
            .decodeIfPresent([String: AnyCodable].self, forKey: .templateOptions)?
            .mapValues { $0.value }

        destinationPath = try container.decodeIfPresent(forKey: .destinationPath)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> GenerationConfiguration {
        guard let base = base else {
            return self
        }

        return GenerationConfiguration(
            file: file ?? base.file,
            accessToken: accessToken ?? base.accessToken,
            templatePath: templatePath,
            templateOptions: templateOptions,
            destinationPath: destinationPath
        )
    }
}
