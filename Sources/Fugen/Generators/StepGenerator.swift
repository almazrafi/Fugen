import Foundation
import PromiseKit

protocol StepGenerator {

    // MARK: - Instance Properties

    var defaultTemplateType: RenderTemplateType { get }
    var defaultDestination: RenderDestination { get }

    // MARK: - Instance Methods

    func generate(configuration: StepConfiguration) -> Promise<Void>
    func generate(parameters: StepParameters) -> Promise<Void>
}

extension StepGenerator {

    // MARK: - Instance Methods

    func generate(configuration: StepConfiguration) -> Promise<Void> {
        guard let fileConfiguration = configuration.file else {
            return .error(StepGeneratorError.invalidFileConfiguration)
        }

        guard let accessToken = configuration.accessToken, !accessToken.isEmpty else {
            return .error(StepGeneratorError.invalidAccessToken)
        }

        let templateType: RenderTemplateType

        if let templatePath = configuration.templatePath {
            templateType = .custom(path: templatePath)
        } else {
            templateType = defaultTemplateType
        }

        let template = RenderTemplate(
            type: templateType,
            options: configuration.templateOptions ?? [:]
        )

        let destination: RenderDestination

        if let destinationPath = configuration.destinationPath {
            destination = .file(path: destinationPath)
        } else {
            destination = defaultDestination
        }

        let parameters = StepParameters(
            fileKey: fileConfiguration.key,
            fileVersion: fileConfiguration.version,
            includedNodes: fileConfiguration.includedNodes,
            excludedNodes: fileConfiguration.excludedNodes,
            accessToken: accessToken,
            template: template,
            destination: destination
        )

        return generate(parameters: parameters)
    }
}
