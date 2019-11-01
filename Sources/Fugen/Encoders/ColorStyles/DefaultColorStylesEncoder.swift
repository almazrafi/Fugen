import Foundation

final class DefaultColorStylesEncoder: ColorStylesEncoder {

    // MARK: - Instance Properties

    let colorEncoder: ColorEncoder

    // MARK: - Initializers

    init(colorEncoder: ColorEncoder) {
        self.colorEncoder = colorEncoder
    }

    // MARK: - Instance Methods

    func encodeColorStyle(_ colorStyle: ColorStyle) -> [String: Any] {
        return [
            "name": colorStyle.name,
            "color": colorEncoder.encodeColor(colorStyle.color)
        ]
    }

    func encodeColorStyles(_ colorStyles: [ColorStyle]) -> [String: Any] {
        return ["colorStyles": colorStyles.map(encodeColorStyle)]
    }
}
