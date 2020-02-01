import Foundation

final class StencilColorRGBAHexInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBAHexInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbHexInfoFilter = StencilColorRGBHexInfoFilter(contextCoder: contextCoder)
        let rgbHexInfo = try rgbHexInfoFilter.filter(color: color)

        guard let alpha = colorComponentHexByte(color.alpha) else {
            throw StencilFilterError(code: .invalidValue(color), filter: name)
        }

        return "\(rgbHexInfo)\(alpha)"
    }
}
