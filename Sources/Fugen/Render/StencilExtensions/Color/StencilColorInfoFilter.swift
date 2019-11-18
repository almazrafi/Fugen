import Foundation

class StencilColorInfoFilter: StencilColorFilter {

    // MARK: - Nested Types

    typealias Output = String

    // MARK: - Instance Properties

    let name = "colorInfo"

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbaHexInfoFilter = StencilColorRGBAHexInfoFilter(colorCoder: colorCoder)
        let rgbaHexInfo = try rgbaHexInfoFilter.filter(color: color)

        let rgbaInfoFilter = StencilColorRGBAInfoFilter(colorCoder: colorCoder)
        let rgbaInfo = try rgbaInfoFilter.filter(color: color)

        return "Hex \(rgbaHexInfo); rgba \(rgbaInfo)"
    }
}
