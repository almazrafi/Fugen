import Foundation
import PromiseKit

final class KitGenerator {

    // MARK: - Instance Properties

    let configurationProvider: ConfigurationProvider
    let colorStylesGenerator: ColorStylesGenerator
    let textStylesGenerator: TextStylesGenerator

    // MARK: - Initializers

    init(
        configurationProvider: ConfigurationProvider,
        colorStylesGenerator: ColorStylesGenerator,
        textStylesGenerator: TextStylesGenerator
    ) {
        self.configurationProvider = configurationProvider
        self.colorStylesGenerator = colorStylesGenerator
        self.textStylesGenerator = textStylesGenerator
    }

    // MARK: - Instance Methods

    private func generate(configuration: Configuration) -> Promise<Void> {
        let promises = [
            colorStylesGenerator.generate(configuration: configuration.resolveColorStyles()),
            textStylesGenerator.generate(configuration: configuration.resolveTextStyles())
        ]

        return when(fulfilled: promises)
    }

    // MARK: -

    func generate(configurationPath: String) -> Promise<Void> {
        return firstly {
            self.configurationProvider.fetchConfiguration(from: configurationPath)
        }.then { configuration in
            self.generate(configuration: configuration)
        }
    }
}
