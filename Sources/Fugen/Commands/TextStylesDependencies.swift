import Foundation

protocol TextStylesDependencies {

    // MARK: - Instance Methods

    func makeTextStylesProvider() -> TextStylesProvider
    func makeTextStylesEncoder() -> TextStylesEncoder
    func makeTemplateRenderer() -> TemplateRenderer
}
