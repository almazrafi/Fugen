import Foundation
import SwiftCLI
import PromiseKit

final class KitCommand: AsyncCommand {

    // MARK: - Type Properties

    static let defaultConfigurationPath = ".fugen.yml"

    // MARK: - Instance Properties

    let name = "kit"
    let shortDescription = "Generates code from Figma files using a configuration file."

    let configurationPath = Key<String>(
        "--config",
        "-c",
        description: """
            Path to the configuration file.
            Defaults to '\(defaultConfigurationPath)'.
            """
    )

    let generator: KitGenerator

    // MARK: - Initializers

    init(generator: KitGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    func executeAndExit() throws {
        let configurationPath = self.configurationPath.value ?? Self.defaultConfigurationPath

        firstly {
            self.generator.generate(configurationPath: configurationPath)
        }.done {
            self.succeed()
        }.catch { error in
            self.fail(error: error)
        }
    }
}
