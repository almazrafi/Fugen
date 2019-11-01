import Foundation

protocol ColorStylesDependencies {

    // MARK: - Instance Methods

    func makeColorStylesProvider() -> ColorStylesProvider
    func makeColorStylesEncoder() -> ColorStylesEncoder
    func makeTemplateRenderer() -> TemplateRenderer
}
