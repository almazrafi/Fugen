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
        if let templatePath = configuration.template {
            return .custom(path: templatePath)
        } else {
            return defaultTemplateType
        }
    }

    private func resolveDestination(configuration: GenerationConfiguration) -> RenderDestination {
        if let destinationPath = configuration.destination {
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

        let file = FileParameters(
            key: fileConfiguration.key,
            version: fileConfiguration.version,
            accessToken: accessToken
        )

        let nodes = NodesParameters(
            includedIDs: fileConfiguration.includedNodes,
            excludedIDs: fileConfiguration.excludedNodes
        )

        let templateType = resolveTemplateType(configuration: configuration)
        let destination = resolveDestination(configuration: configuration)

        let template = RenderTemplate(
            type: templateType,
            options: configuration.templateOptions ?? [:]
        )

        let render = RenderParameters(template: template, destination: destination)

        return GenerationParameters(file: file, nodes: nodes, render: render)
    }
}
