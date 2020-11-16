import Foundation

struct TextStyleNode: Encodable, Hashable {

    // MARK: - Instance Properties

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
