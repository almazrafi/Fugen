import Foundation
import FugenTools
import PromiseKit

final class DefaultShadowStylesGenerator: ShadowStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let shadowStylesProvider: ShadowStylesProvider
    let templateRenderer: TemplateRenderer

    let defaultTemplateType: RenderTemplateType = .native(name: "ShadowStyles")
    let defaultDestination: RenderDestination = .console

    // MARK: - Initializers

    init(shadowStylesProvider: ShadowStylesProvider, templateRenderer: TemplateRenderer) {
        self.shadowStylesProvider = shadowStylesProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) -> Promise<Void> {
        return firstly {
            self.shadowStylesProvider.fetchShadowStyles(from: parameters.file, nodes: parameters.nodes)
        }.map { shadowStyles in
            ShadowStylesContext(shadowStyles: shadowStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
        }
    }

    // MARK: - ShadowStylesGenerator

    func generate(configuration: ShadowStylesConfiguration) -> Promise<Void> {
        return perform(on: .global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration)
        }.then { parameters in
            self.generate(parameters: parameters)
        }
    }
}
