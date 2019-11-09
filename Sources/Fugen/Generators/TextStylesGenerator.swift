import Foundation
import PromiseKit

final class TextStylesGenerator: StepGenerator {

    // MARK: - Instance Properties

    let textStylesProvider: TextStylesProvider
    let textStylesEncoder: TextStylesEncoder
    let templateRenderer: TemplateRenderer

    // MARK: - StepGenerator

    let defaultTemplateType = RenderTemplateType.native(name: "TextStyles")
    let defaultDestination = RenderDestination.console

    // MARK: - Initializers

    init(
        textStylesProvider: TextStylesProvider,
        textStylesEncoder: TextStylesEncoder,
        templateRenderer: TemplateRenderer
    ) {
        self.textStylesProvider = textStylesProvider
        self.textStylesEncoder = textStylesEncoder
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    func generate(parameters: StepParameters) -> Promise<Void> {
        return firstly {
            self.textStylesProvider.fetchTextStyles(
                fileKey: parameters.fileKey,
                fileVersion: parameters.fileVersion,
                includingNodes: parameters.includedNodes,
                excludingNodes: parameters.excludedNodes,
                accessToken: parameters.accessToken
            )
        }.map { textStyles in
            self.textStylesEncoder.encodeTextStyles(textStyles)
        }.done { context in
            try self.templateRenderer.renderTemplate(
                parameters.template,
                to: parameters.destination,
                context: context
            )
        }
    }
}
