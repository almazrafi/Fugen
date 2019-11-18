import Foundation

class StencilColorRGBHexInfoFilter: StencilColorFilter {

    // MARK: - Nested Types

    typealias Output = String

    // MARK: - Instance Properties

    let name = "colorRGBHexInfo"

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        guard let red = colorComponentHexByte(color.red) else {
            throw StencilFilterError.invalidValue(color, filter: name)
        }

        guard let green = colorComponentHexByte(color.green) else {
            throw StencilFilterError.invalidValue(color, filter: name)
        }

        guard let blue = colorComponentHexByte(color.blue) else {
            throw StencilFilterError.invalidValue(color, filter: name)
        }

        return "#\(red)\(green)\(blue)"
    }
}
