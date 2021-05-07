import Foundation

final class StencilFontSystemFilter: StencilFontFilter {

    // MARK: - Instance Properties

    let name = "isSystemFont"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(font: Font) throws -> Bool {
        font.isSystemFont
    }
}
