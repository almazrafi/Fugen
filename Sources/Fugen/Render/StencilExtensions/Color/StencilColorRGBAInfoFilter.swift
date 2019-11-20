import Foundation

final class StencilColorRGBAInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBAInfo"

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbInfoFilter = StencilColorRGBInfoFilter(colorCoder: colorCoder)
        let rgbInfo = try rgbInfoFilter.filter(color: color)

        return "\(rgbInfo), \(Int(color.alpha * 100.0))%"
    }
}
