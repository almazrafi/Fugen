import Foundation
import Stencil

final class StencilFontExtension: StencilExtension {

    // MARK: - Instance Properties

    let fontCoder: FontCoder

    // MARK: - Initializers

    init(fontCoder: FontCoder) {
        self.fontCoder = fontCoder
    }

    // MARK: - Instance Methods

    private func extractFont(from value: Any?, filter: String) throws -> Font {
        guard let encodedFont = value as? [String: Any] else {
            throw StencilExtensionError.invalidFilterValue(value, filter: filter)
        }

        guard let font = fontCoder.decodeFont(from: encodedFont) else {
            throw StencilExtensionError.invalidFilterValue(value, filter: filter)
        }

        return font
    }

    private func fontInfo(from value: Any?) throws -> String? {
        let font = try extractFont(from: value, filter: .stencilFontInfoFilter)

        return "Font: \(font.family) (\(font.name)); weight \(font.weight); size \(font.size)"
    }

    // MARK: -

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(.stencilFontInfoFilter, filter: fontInfo)
    }
}

private extension String {

    // MARK: - Instance Properties

    static let stencilFontInfoFilter = "fontInfo"
}
