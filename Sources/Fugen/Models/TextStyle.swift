import Foundation

struct TextStyle: Hashable {

    // MARK: - Instance Properties

    let name: String
    let font: Font
    let textColor: Color
    let strikethrough: Bool
    let underline: Bool
    let paragraphSpacing: Double?
    let paragraphIndent: Double?
    let lineHeight: Double?
    let letterSpacing: Double?
}
