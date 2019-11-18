import Foundation

final class DefaultTextStylesCoder: TextStylesCoder {

    // MARK: - Instance Properties

    let fontCoder: FontCoder
    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(
        fontCoder: FontCoder,
        colorCoder: ColorCoder
    ) {
        self.fontCoder = fontCoder
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    func encodeTextStyle(_ textStyle: TextStyle) -> [String: Any] {
        var encodedTextStyle: [String: Any] = [
            "name": textStyle.name,
            "font": fontCoder.encodeFont(textStyle.font),
            "color": colorCoder.encodeColor(textStyle.color),
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
