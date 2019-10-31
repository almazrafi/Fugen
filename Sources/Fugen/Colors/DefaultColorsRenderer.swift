import Foundation

final class DefaultColorsRenderer: ColorsRenderer {

    // MARK: - Instance Properties

    let templateRenderer: TemplateRenderer

    // MARK: - Initializers

    init(templateRenderer: TemplateRenderer) {
        self.templateRenderer = templateRenderer
    }

    // MARK: - Instance Methods

    private func makeHexComponent(from number: Double) -> String {
        return String(format: "%02lX", Int(number * 255.0))
    }

    private func makeContext(with colors: [Color]) -> [String: Any] {
        let colors = colors.map { color in
            return [
                "name": color.name,
                "red": makeHexComponent(from: color.red),
                "green": makeHexComponent(from: color.green),
                "blue": makeHexComponent(from: color.blue),
                "alpha": makeHexComponent(from: color.alpha)
            ]
        }

        return ["colors": colors]
    }

    // MARK: - ColorsRenderer

    func renderTemplate(_ template: RenderTemplate, to destination: RenderDestination, colors: [Color]) throws {
        try templateRenderer.renderTemplate(template, to: destination, context: makeContext(with: colors))
    }
}
