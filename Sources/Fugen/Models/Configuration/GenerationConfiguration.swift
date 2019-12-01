import Foundation
import FugenTools

struct GenerationConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
        case template
        case templateOptions
        case destination
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: String?
    let template: String?
    let templateOptions: [String: Any]?
    let destination: String?

    // MARK: - Initializers

    init(
        file: FileConfiguration?,
        accessToken: String?,
        template: String?,
        templateOptions: [String: Any]?,
        destination: String?
    ) {
        self.file = file
        self.accessToken = accessToken
        self.template = template
        self.templateOptions = templateOptions
        self.destination = destination
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        file = try container.decodeIfPresent(forKey: .file)
        accessToken = try container.decodeIfPresent(forKey: .accessToken)
        template = try container.decodeIfPresent(forKey: .template)

        templateOptions = try container
            .decodeIfPresent([String: AnyCodable].self, forKey: .templateOptions)?
            .mapValues { $0.value }

        destination = try container.decodeIfPresent(forKey: .destination)
    }

    // MARK: - Instance Methods

    func resolve(base: BaseConfiguration?) -> GenerationConfiguration {
        guard let base = base else {
            return self
        }

        return GenerationConfiguration(
            file: file ?? base.file,
            accessToken: accessToken ?? base.accessToken,
            template: template,
            templateOptions: templateOptions,
            destination: destination
        )
    }
}
