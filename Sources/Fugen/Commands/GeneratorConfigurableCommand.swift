import Foundation
import SwiftCLI

protocol GeneratorConfigurableCommand: Command {

    // MARK: - Instance Properties

    var fileKey: Key<String> { get }
    var fileVersion: Key<String> { get }
    var includedNodes: VariadicKey<String> { get }
    var excludedNodes: VariadicKey<String> { get }

    var accessToken: Key<String> { get }

    var templatePath: Key<String> { get }
    var templateOptions: VariadicKey<String> { get }
    var destinationPath: Key<String> { get }

    var generatorConfiguration: GeneratorConfiguration { get }
}

extension GeneratorConfigurableCommand {

    // MARK: - Instance Properties

    var generatorConfiguration: GeneratorConfiguration {
        GeneratorConfiguration(
            file: resolveFileConfiguration(),
            accessToken: accessToken.value,
            templatePath: templatePath.value,
            templateOptions: resolveTemplateOptions(),
            destinationPath: destinationPath.value
        )
    }

    // MARK: - Instance Methods

    private func resolveFileConfiguration() -> FileConfiguration? {
        guard let fileKey = fileKey.value else {
            return nil
        }

        return FileConfiguration(
            key: fileKey,
            version: fileVersion.value,
            includedNodes: includedNodes.value,
            excludedNodes: excludedNodes.value
        )
    }

    private func resolveTemplateOptions() -> [String: Any] {
        var templateOptions: [String: String] = [:]

        for templateOption in self.templateOptions.value {
            var optionComponents = templateOption.components(separatedBy: String.templateOptionSeparator)
            let optionKey = optionComponents.removeFirst().trimmingCharacters(in: .whitespaces)
            let optionValue = optionComponents.joined(separator: .templateOptionSeparator)

            templateOptions[optionKey] = optionValue
        }

        return templateOptions
    }
}

private extension String {

    // MARK: - Type Properties

    static let templateOptionSeparator = ":"
}
