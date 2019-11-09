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

    private func generate(configuration: Configuration) -> Promise<Void> {
        var promises: [Promise<Void>] = []

        if let colorStylesConfiguration = configuration.resolveColorStyles() {
            promises.append(colorStylesGenerator.generate(configuration: colorStylesConfiguration))
        }

        if let textStylesConfiguration = configuration.resolveTextStyles() {
            promises.append(textStylesGenerator.generate(configuration: textStylesConfiguration))
        }

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
