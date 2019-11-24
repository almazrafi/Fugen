import Foundation

protocol GenerationParametersResolving {

    // MARK: - Instance Properties

    var defaultTemplateType: RenderTemplateType { get }
    var defaultDestination: RenderDestination { get }

    // MARK: - Instance Methods

    func resolveGenerationParameters(from configuration: GenerationConfiguration) throws -> GenerationParameters
}

extension GenerationParametersResolving {

    // MARK: - Instance Methods

    private func resolveTemplateType(configuration: GenerationConfiguration) -> RenderTemplateType {
        if let templatePath = configuration.templatePath {
            return .custom(path: templatePath)
        } else {
            return defaultTemplateType
        }
    }

    private func resolveDestination(configuration: GenerationConfiguration) -> RenderDestination {
        if let destinationPath = configuration.destinationPath {
            return .file(path: destinationPath)
        } else {
            return defaultDestination
        }
    }

    // MARK: -

    func resolveGenerationParameters(from configuration: GenerationConfiguration) throws -> GenerationParameters {
        guard let fileConfiguration = configuration.file else {
            throw GenerationParametersError.invalidFileConfiguration
        }

        guard let accessToken = configuration.accessToken, !accessToken.isEmpty else {
            throw GenerationParametersError.invalidAccessToken
        }

        let templateType = resolveTemplateType(configuration: configuration)
        let destination = resolveDestination(configuration: configuration)

        let template = RenderTemplate(
            type: templateType,
            options: configuration.templateOptions ?? [:]
        )

        return GenerationParameters(
            fileKey: fileConfiguration.key,
            fileVersion: fileConfiguration.version,
            includedNodes: fileConfiguration.includedNodes,
            excludedNodes: fileConfiguration.excludedNodes,
            accessToken: accessToken,
            template: template,
            destination: destination
        )
    }
}
