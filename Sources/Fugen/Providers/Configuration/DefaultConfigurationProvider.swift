import Foundation
import PromiseKit
import Yams
import PathKit

final class DefaultConfigurationProvider: ConfigurationProvider {

    // MARK: - Instance Properties

    private let decoder = YAMLDecoder()

    // MARK: - Instance Methods

    func fetchConfiguration(from configurationPath: String) -> Promise<Configuration> {
        return Promise { seal in
            let configurationPath = Path(configurationPath)
            let configurationContent = try configurationPath.read(.utf8)

            seal.fulfill(try decoder.decode(Configuration.self, from: configurationContent))
        }
    }
}
