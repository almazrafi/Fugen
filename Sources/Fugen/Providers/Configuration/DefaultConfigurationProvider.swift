import Foundation
import Yams
import PathKit

final class DefaultConfigurationProvider: ConfigurationProvider {

    // MARK: - Instance Properties

    private let decoder = YAMLDecoder()

    // MARK: - Instance Methods

    func fetchConfiguration(from configurationPath: String) throws -> Configuration {
        let configurationPath = Path(configurationPath)
        let configurationContent = try configurationPath.read(.utf8)

        return try decoder.decode(Configuration.self, from: configurationContent)
    }
}
