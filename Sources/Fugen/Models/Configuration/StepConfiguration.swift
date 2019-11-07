import Foundation
import FugenTools

struct StepConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
        case templatePath
        case destinationPath
        case options
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
            .decodeIfPresent([String: AnyCodable].self, forKey: .options)?
            .mapValues { $0.value }

        destinationPath = try container.decodeIfPresent(forKey: .destinationPath)
    }
}
