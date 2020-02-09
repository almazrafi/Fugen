import Foundation
import SwiftCLI

protocol GenerationConfigurableCommand: Command {

    // MARK: - Instance Properties

    var fileKey: Key<String> { get }
    var fileVersion: Key<String> { get }
    var includedNodes: VariadicKey<String> { get }
    var excludedNodes: VariadicKey<String> { get }

    var accessToken: Key<String> { get }

    var template: Key<String> { get }
    var templateOptions: VariadicKey<String> { get }
    var destination: Key<String> { get }

    var generationConfiguration: GenerationConfiguration { get }
}

extension GenerationConfigurableCommand {

    // MARK: - Instance Properties

    var generationConfiguration: GenerationConfiguration {
        GenerationConfiguration(
            file: resolveFileConfiguration(),
            accessToken: resolveAccessTokenConfiguration(),
            template: template.value,
            templateOptions: resolveTemplateOptions(),
            destination: destination.value
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

    private func resolveAccessTokenConfiguration() -> AccessTokenConfiguration? {
        guard let accessToken = accessToken.value else {
            return nil
        }

        return .value(accessToken)
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
