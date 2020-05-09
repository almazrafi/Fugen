import Foundation
import PromiseKit

final class DefaultLibraryGenerator: LibraryGenerator {

    // MARK: - Instance Properties

    let configurationProvider: ConfigurationProvider
    let colorStylesGenerator: ColorStylesGenerator
    let textStylesGenerator: TextStylesGenerator
    let imagesGenerator: ImagesGenerator
    let shadowStylesGenerator: ShadowStylesGenerator

    // MARK: - Initializers

    init(
        configurationProvider: ConfigurationProvider,
        colorStylesGenerator: ColorStylesGenerator,
        textStylesGenerator: TextStylesGenerator,
        imagesGenerator: ImagesGenerator,
        shadowStylesGenerator: ShadowStylesGenerator
    ) {
        self.configurationProvider = configurationProvider
        self.colorStylesGenerator = colorStylesGenerator
        self.textStylesGenerator = textStylesGenerator
        self.imagesGenerator = imagesGenerator
        self.shadowStylesGenerator = shadowStylesGenerator
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

        if let shadowStylesConfiguration = configuration.resolveShadowStyles() {
            promises.append(shadowStylesGenerator.generate(configuration: shadowStylesConfiguration))
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
