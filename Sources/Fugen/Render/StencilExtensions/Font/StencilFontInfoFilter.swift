import Foundation

final class StencilFontInfoFilter: StencilFontFilter {

    // MARK: - Instance Properties

    let name = "fontInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(font: Font) throws -> String {
        return "Font: \(font.family) (\(font.name)); weight \(font.weight); size \(font.size)"
    }
}
