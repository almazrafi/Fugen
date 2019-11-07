import Foundation
import SwiftCLI
import PromiseKit

protocol StepCommand: AsyncCommand {

    // MARK: - Nested Types

    associatedtype Generator: StepGenerator

    // MARK: - Instance Properties

    var fileKey: Key<String> { get }
    var includedNodes: VariadicKey<String> { get }
    var excludedNodes: VariadicKey<String> { get }

    var accessToken: Key<String> { get }

    var templatePath: Key<String> { get }
    var templateOptions: VariadicKey<String> { get }
    var destinationPath: Key<String> { get }

    var generator: Generator { get }
}

extension StepCommand {

    // MARK: - Instance Methods

    private func resolveFileConfiguration() -> FileConfiguration? {
        guard let fileKey = fileKey.value else {
            return nil
        }

        return FileConfiguration(
            key: fileKey,
            version: nil,
            includedNodes: includedNodes.value,
            excludedNodes: excludedNodes.value
        )
    }

    private func resolveTemplateOptions() -> [String: Any] {
        var templateOptions: [String: String] = [:]

        for templateOption in self.templateOptions.value {
            var optionComponents = templateOption.components(separatedBy: ":")

            guard optionComponents.count > 1 else {
                fail(message: "Invalid format of template option '\(templateOption)'")
            }

            let optionKey = optionComponents.removeFirst().trimmingCharacters(in: .whitespaces)
            let optionValue = optionComponents.joined(separator: ":")

            templateOptions[optionKey] = optionValue
        }

        return templateOptions
    }

    private func resolveStepConfiguration() -> StepConfiguration {
        return StepConfiguration(
            file: resolveFileConfiguration(),
            accessToken: accessToken.value,
            templatePath: templatePath.value,
            templateOptions: resolveTemplateOptions(),
            destinationPath: destinationPath.value
        )
    }

    // MARK: - AsyncCommand

    func executeAndExit() throws {
        let stepConfiguration = resolveStepConfiguration()

        firstly {
            self.generator.generate(configuration: stepConfiguration)
        }.done {
            self.succeed()
        }.catch { error in
            self.fail(error: error)
        }
    }
}
