import Foundation

final class StencilColorRGBInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBInfo"

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        guard let red = colorComponentByte(color.red) else {
            throw StencilFilterError(code: .invalidValue(color), filter: name)
        }

        guard let green = colorComponentByte(color.green) else {
            throw StencilFilterError(code: .invalidValue(color), filter: name)
        }

        guard let blue = colorComponentByte(color.blue) else {
            throw StencilFilterError(code: .invalidValue(color), filter: name)
        }

        return "\(red) \(green) \(blue)"
    }
}
