import Foundation

final class DefaultFontEncoder: FontEncoder {

    // MARK: - Instance Methods

    func encodeFont(_ font: Font) -> [String: Any] {
        return [
            "family": font.family,
            "name": font.name,
            "weight": "\(font.weight)",
            "size": "\(font.size)"
        ]
    }
}
