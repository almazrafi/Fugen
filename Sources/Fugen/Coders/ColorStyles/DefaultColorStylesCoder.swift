import Foundation

final class DefaultColorStylesCoder: ColorStylesCoder {

    // MARK: - Instance Properties

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func encodeColorStyle(_ colorStyle: ColorStyle) -> [String: Any] {
        return [
            "name": colorStyle.name,
            "color": colorCoder.encodeColor(colorStyle.color)
        ]
    }

    func encodeColorStyles(_ colorStyles: [ColorStyle]) -> [String: Any] {
        return ["colorStyles": colorStyles.map(encodeColorStyle)]
    }
}
