import Foundation

protocol GeneratorParametersResolving {

    // MARK: - Instance Properties

    var defaultTemplateType: RenderTemplateType { get }
    var defaultDestination: RenderDestination { get }

    // MARK: - Instance Methods

    func resolveGeneratorParameters(from configuration: GeneratorConfiguration) throws -> GeneratorParameters
}

extension GeneratorParametersResolving {

    // MARK: - Instance Methods

    private func resolveTemplateType(configuration: GeneratorConfiguration) -> RenderTemplateType {
        if let templatePath = configuration.templatePath {
            return .custom(path: templatePath)
        } else {
            return defaultTemplateType
        }
    }

    private func resolveDestination(configuration: GeneratorConfiguration) -> RenderDestination {
        if let destinationPath = configuration.destinationPath {
            return .file(path: destinationPath)
        } else {
            return defaultDestination
        }
    }

    // MARK: -

    func resolveGeneratorParameters(from configuration: GeneratorConfiguration) throws -> GeneratorParameters {
        guard let fileConfiguration = configuration.file else {
            throw GeneratorParametersError.invalidFileConfiguration
        }

        guard let accessToken = configuration.accessToken, !accessToken.isEmpty else {
            throw GeneratorParametersError.invalidAccessToken
        }

        let templateType = resolveTemplateType(configuration: configuration)
        let destination = resolveDestination(configuration: configuration)

        let template = RenderTemplate(
            type: templateType,
            options: configuration.templateOptions ?? [:]
        )

        return GeneratorParameters(
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
