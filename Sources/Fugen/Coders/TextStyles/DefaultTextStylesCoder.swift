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
        let info = textStyle.info
        let colorInfo = textStyle.colorInfo

        var encodedTextStyle: [String: Any] = [
            "name": info.name,
            "font": fontCoder.encodeFont(info.font),
            "color": colorCoder.encodeColor(colorInfo.color),
            "strikethrough": info.strikethrough,
            "underline": info.underline
        ]

        if let description = info.description {
            encodedTextStyle["description"] = description
        }

        if let colorStyleName = colorInfo.styleName {
            encodedTextStyle["colorStyleName"] = colorStyleName
        }

        if let paragraphSpacing = info.paragraphSpacing {
            encodedTextStyle["paragraphSpacing"] = paragraphSpacing.rounded(precision: 4)
        }

        if let paragraphIndent = info.paragraphIndent {
            encodedTextStyle["paragraphIndent"] = paragraphIndent.rounded(precision: 4)
        }

        if let lineHeight = info.lineHeight {
            encodedTextStyle["lineHeight"] = lineHeight.rounded(precision: 4)
        }

        if let letterSpacing = info.letterSpacing {
            encodedTextStyle["letterSpacing"] = letterSpacing.rounded(precision: 4)
        }

        return encodedTextStyle
    }

    func encodeTextStyles(_ textStyles: [TextStyle]) -> [String: Any] {
        return ["textStyles": textStyles.map(encodeTextStyle)]
    }
}
