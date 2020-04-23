import Foundation

struct TextStyleNode: Encodable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?
    let font: Font
    let strikethrough: Bool
    let underline: Bool
    let paragraphSpacing: Double?
    let paragraphIndent: Double?
    let lineHeight: Double?
    let letterSpacing: Double?
}

extension TextStyleNode: Hashable {
    static func == (lhs: TextStyleNode, rhs: TextStyleNode) -> Bool {
        return lhs.name == rhs.name &&
            lhs.font == rhs.font &&
            lhs.strikethrough == rhs.strikethrough &&
            lhs.underline == rhs.underline &&
            lhs.paragraphSpacing == rhs.paragraphSpacing &&
            lhs.paragraphIndent == rhs.paragraphIndent &&
            lhs.lineHeight == rhs.lineHeight &&
            lhs.letterSpacing == rhs.letterSpacing
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(font)
        hasher.combine(strikethrough)
        hasher.combine(underline)
        hasher.combine(paragraphSpacing)
        hasher.combine(paragraphIndent)
        hasher.combine(lineHeight)
        hasher.combine(letterSpacing)
    }
}
