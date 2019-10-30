import Foundation

protocol ColorsRenderer {

    // MARK: - Instance Methods

    func renderTemplate(_ template: RenderTemplate, to destination: RenderDestination, colors: [Color]) throws
}
