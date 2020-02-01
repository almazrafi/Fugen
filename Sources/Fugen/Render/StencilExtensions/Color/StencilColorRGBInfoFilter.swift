import Foundation

final class StencilColorRGBInfoFilter: StencilColorFilter {

    // MARK: - Instance Properties

    let name = "colorRGBInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
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
