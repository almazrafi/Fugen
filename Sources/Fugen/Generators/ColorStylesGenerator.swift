import Foundation
import PromiseKit

final class ColorStylesGenerator: StepGenerator {

    // MARK: - Instance Properties

    let colorStylesProvider: ColorStylesProvider
    let colorStylesEncoder: ColorStylesEncoder
    let templateRenderer: TemplateRenderer

    // MARK: - StepGenerator

    let defaultTemplateType = RenderTemplateType.native(name: "ColorStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        colorStylesProvider: ColorStylesProvider,
        colorStylesEncoder: ColorStylesEncoder,
        templateRenderer: TemplateRenderer
    ) {
        self.colorStylesProvider = colorStylesProvider
        self.colorStylesEncoder = colorStylesEncoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func generate(parameters: StepParameters) -> Promise<Void> {
        return firstly {
            self.colorStylesProvider.fetchColorStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.map { colorStyles in
            self.colorStylesEncoder.encodeColorStyles(colorStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.template,
                to: parameters.destination,
                context: context
            )
        }
    }
}
