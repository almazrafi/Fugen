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
            "textColor": colorEncoder.encodeColor(textStyle.textColor),
            "strikethrough": "\(textStyle.strikethrough)",
            "underline": "\(textStyle.underline)"
        ]

        if let paragraphSpacing = textStyle.paragraphSpacing {
            encodedTextStyle["paragraphSpacing"] = "\(paragraphSpacing)"
        }

        if let paragraphIndent = textStyle.paragraphIndent {
            encodedTextStyle["paragraphIndent"] = "\(paragraphIndent)"
        }

        if let lineHeight = textStyle.lineHeight {
            encodedTextStyle["lineHeight"] = "\(lineHeight)"
        }

        if let letterSpacing = textStyle.letterSpacing {
            encodedTextStyle["letterSpacing"] = "\(letterSpacing)"
        }

        return encodedTextStyle
    }

    func encodeTextStyles(_ textStyles: [TextStyle]) -> [String: Any] {
        return ["textStyles": textStyles.map(encodeTextStyle)]
    }
}
