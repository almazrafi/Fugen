import Foundation
import PromiseKit

final class DefaultKitGenerator: KitGenerator {

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

    private func generateColorStylesIfNeeded(configuration: Configuration) -> Promise<Void> {
        guard let colorStylesConfiguration = configuration.resolveColorStyles() else {
            return .value(Void())
        }

        return colorStylesGenerator.generate(configuration: colorStylesConfiguration)
    }

    private func generateTextStylesIfNeeded(configuration: Configuration) -> Promise<Void> {
        guard let textStylesConfiguration = configuration.resolveTextStyles() else {
            return .value(Void())
        }

        return textStylesGenerator.generate(configuration: textStylesConfiguration)
    }

    private func generate(configuration: Configuration) -> Promise<Void> {
        let promises = [
            generateColorStylesIfNeeded(configuration: configuration),
            generateTextStylesIfNeeded(configuration: configuration)
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
