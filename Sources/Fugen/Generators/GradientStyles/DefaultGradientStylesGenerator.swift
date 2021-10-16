import Foundation
import PromiseKit
import FugenTools

final class DefaultGradientStylesGenerator: GradientStylesGenerator, GenerationParametersResolving {

    // MARK: - Instance Properties

    let gradientStylesProvider: GradientStylesProvider
    let templateRenderer: TemplateRenderer

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(gradientStylesProvider: GradientStylesProvider, templateRenderer: TemplateRenderer) {
        self.gradientStylesProvider = gradientStylesProvider
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func generate(parameters: GenerationParameters) -> Promise<Void> {
        firstly {
            gradientStylesProvider.fetchGradientStyles(from: parameters.file, nodes: parameters.nodes)
        }.map { gradientStyles in
            GradientStylesContext(gradientStyles: gradientStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.render.template,
                to: parameters.render.destination,
                context: context
            )
        }
    }

    // MARK: -

    func generate(configuration: GradientStylesConfiguration) -> Promise<Void> {
        perform(on: .global(qos: .userInitiated)) {
            try self.resolveGenerationParameters(from: configuration)
        }.then { parameters in
            self.generate(parameters: parameters)
        }
    }
}
