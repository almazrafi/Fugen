import Foundation

struct FigmaTypeStyle: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case fontFamily
        case fontPostScriptName
        case fontWeight
        case fontSize
        case isItalic = "italic"
        case paragraphSpacing
        case paragraphIndent
        case rawTextCase = "textCase"
        case rawTextDecoration = "textDecoration"
        case rawTextHorizontalAlignment = "textAlignHorizontal"
        case rawTextVerticalAlignment = "textAlignVertical"
        case letterSpacing
        case fills
        case lineHeight = "lineHeightPx"
        case lineHeightPercentFontSize = "lineHeightPercentFontSize"
        case rawLineHeightUnit = "lineHeightUnit"
    }

    // MARK: - Instance Properties

    let fontFamily: String?
    let fontPostScriptName: String?
    let fontWeight: Double?
    let fontSize: Double?
    let isItalic: Bool?
    let paragraphSpacing: Double?
    let paragraphIndent: Double?
    let rawTextCase: String?
    let rawTextDecoration: String?
    let rawTextHorizontalAlignment: String?
    let rawTextVerticalAlignment: String?
    let letterSpacing: Double?
    let fills: [FigmaPaint]?
    let lineHeight: Double?
    let lineHeightPercentFontSize: Double?
    let rawLineHeightUnit: String?

    var textCase: FigmaTextCase? {
        guard let rawTextCase = rawTextCase else {
            return FigmaTextCase.original
        }

        return FigmaTextCase(rawValue: rawTextCase)
    }

    var textDecoration: FigmaTextDecoration? {
        guard let rawTextDecoration = rawTextDecoration else {
            return FigmaTextDecoration.none
        }

        return FigmaTextDecoration(rawValue: rawTextDecoration)
    }

    var textHorizontalAlignment: FigmaTextHorizontalAlignment? {
        rawTextHorizontalAlignment.flatMap(FigmaTextHorizontalAlignment.init)
    }

    var textVericalAlignment: FigmaTextVerticalAlignment? {
        rawTextVerticalAlignment.flatMap(FigmaTextVerticalAlignment.init)
    }

    var lineHeightUnit: FigmaLineHeightUnit? {
        rawLineHeightUnit.flatMap(FigmaLineHeightUnit.init)
    }
}
