import Foundation

final class StencilColorRGBAHexInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBAHexInfo"

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbHexInfoFilter = StencilColorRGBHexInfoFilter(colorCoder: colorCoder)
        let rgbHexInfo = try rgbHexInfoFilter.filter(color: color)

        guard let alpha = colorComponentHexByte(color.alpha) else {
            throw StencilFilterError(code: .invalidValue(color), filter: name)
        }

        return "\(rgbHexInfo)\(alpha)"
    }
}
