import Foundation

final class StencilColorRGBAInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBAInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbInfoFilter = StencilColorRGBInfoFilter(contextCoder: contextCoder)
        let rgbInfo = try rgbInfoFilter.filter(color: color)

        return "\(rgbInfo), \(Int(color.alpha * 100.0))%"
    }
}
