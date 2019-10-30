import Foundation

protocol TemplateRenderer {

    // MARK: - Instance Methods

    func renderTemplate(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: [String: Any]
    ) throws
}
