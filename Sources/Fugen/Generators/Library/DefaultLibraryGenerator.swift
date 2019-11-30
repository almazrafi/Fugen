import Foundation
import PromiseKit

final class DefaultLibraryGenerator: LibraryGenerator {

    // MARK: - Instance Properties

    let configurationProvider: ConfigurationProvider
    let colorStylesGenerator: ColorStylesGenerator
    let textStylesGenerator: TextStylesGenerator
    let imagesGenerator: ImagesGenerator

    // MARK: - Initializers

    init(
        configurationProvider: ConfigurationProvider,
        colorStylesGenerator: ColorStylesGenerator,
        textStylesGenerator: TextStylesGenerator,
        imagesGenerator: ImagesGenerator
    ) {
        self.configurationProvider = configurationProvider
        self.colorStylesGenerator = colorStylesGenerator
        self.textStylesGenerator = textStylesGenerator
        self.imagesGenerator = imagesGenerator
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

        if let imagesConfiguration = configuration.resolveImages() {
            promises.append(imagesGenerator.generate(configuration: imagesConfiguration))
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
