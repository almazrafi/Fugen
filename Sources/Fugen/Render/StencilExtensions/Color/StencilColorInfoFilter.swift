import Foundation

final class StencilColorInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(color: Color) throws -> String {
        let rgbaHexInfoFilter = StencilColorRGBAHexInfoFilter(contextCoder: contextCoder)
        let rgbaHexInfo = try rgbaHexInfoFilter.filter(color: color)

        let rgbaInfoFilter = StencilColorRGBAInfoFilter(contextCoder: contextCoder)
        let rgbaInfo = try rgbaInfoFilter.filter(color: color)

        return "Hex \(rgbaHexInfo); rgba \(rgbaInfo)"
    }
}
