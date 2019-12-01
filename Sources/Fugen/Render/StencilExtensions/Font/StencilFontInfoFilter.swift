import Foundation

final class StencilFontInfoFilter: StencilFontFilter {

    // MARK: - Instance Properties

    let name = "fontInfo"

    let fontCoder: FontCoder

    // MARK: - Initializers

    init(fontCoder: FontCoder) {
        self.fontCoder = fontCoder
    }

    // MARK: - Instance Methods

    func filter(font: Font) throws -> String {
        return "Font: \(font.family) (\(font.name)); weight \(font.weight); size \(font.size)"
    }
}
