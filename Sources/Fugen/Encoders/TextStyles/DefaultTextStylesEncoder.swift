import Foundation

final class DefaultTextStylesEncoder: TextStylesEncoder {

    // MARK: - Instance Properties

    let fontEncoder: FontEncoder
    let colorEncoder: ColorEncoder

    // MARK: - Initializers

    init(
        fontEncoder: FontEncoder,
        colorEncoder: ColorEncoder
    ) {
        self.fontEncoder = fontEncoder
        self.colorEncoder = colorEncoder
    }

    // MARK: - Instance Methods

    func encodeTextStyle(_ textStyle: TextStyle) -> [String: Any] {
        var encodedTextStyle: [String: Any] = [
            "name": textStyle.name,
            "font": fontEncoder.encodeFont(textStyle.font),
            "color": colorEncoder.encodeColor(textStyle.color),
            "strikethrough": textStyle.strikethrough,
            "underline": textStyle.underline
        ]

        if let colorStyle = textStyle.colorStyle {
            encodedTextStyle["colorStyle"] = colorStyle
        }

        if let paragraphSpacing = textStyle.paragraphSpacing {
            encodedTextStyle["paragraphSpacing"] = paragraphSpacing.rounded(precision: 4)
        }

        if let paragraphIndent = textStyle.paragraphIndent {
            encodedTextStyle["paragraphIndent"] = paragraphIndent.rounded(precision: 4)
        }

        if let lineHeight = textStyle.lineHeight {
            encodedTextStyle["lineHeight"] = lineHeight.rounded(precision: 4)
        }

        if let letterSpacing = textStyle.letterSpacing {
            encodedTextStyle["letterSpacing"] = letterSpacing.rounded(precision: 4)
        }

        return encodedTextStyle
    }

    func encodeTextStyles(_ textStyles: [TextStyle]) -> [String: Any] {
        return ["textStyles": textStyles.map(encodeTextStyle)]
    }
}
