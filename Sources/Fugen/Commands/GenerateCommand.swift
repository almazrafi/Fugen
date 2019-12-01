import Foundation
import SwiftCLI
import PromiseKit

final class GenerateCommand: AsyncExecutableCommand {

    // MARK: - Instance Properties

    let name = "generate"
    let shortDescription = "Generates code from Figma files using a configuration file."

    let configurationPath = Key<String>(
        "--config",
        "-c",
        description: """
            Path to the configuration file.
            Defaults to '\(String.defaultConfigurationPath)'.
            """
    )

    let generator: LibraryGenerator

    // MARK: - Initializers

    init(generator: LibraryGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    func executeAsyncAndExit() throws {
        let configurationPath = self.configurationPath.value ?? .defaultConfigurationPath

        firstly {
            self.generator.generate(configurationPath: configurationPath)
        }.done {
            self.succeed(message: "Generation completed successfully!")
        }.catch { error in
            self.fail(message: "Failed to generate with error: \(error)")
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let defaultConfigurationPath = ".fugen.yml"
}
