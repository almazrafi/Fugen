import Foundation

final class DefaultFontCoder: FontCoder {

    // MARK: - Instance Methods

    func encodeFont(_ font: Font) -> [String: Any] {
        return [
            .fontFamilyCodingKey: font.family,
            .fontNameCodingKey: font.name,
            .fontWeightCodingKey: font.weight.rounded(),
            .fontSizeCodingKey: font.size.rounded()
        ]
    }

    func decodeFont(from encodedFont: [String: Any]) -> Font? {
        guard let family = encodedFont[.fontFamilyCodingKey] as? String else {
            return nil
        }

        guard let name = encodedFont[.fontNameCodingKey] as? String else {
            return nil
        }

        guard let weight = encodedFont[.fontWeightCodingKey] as? Double else {
            return nil
        }

        guard let size = encodedFont[.fontSizeCodingKey] as? Double else {
            return nil
        }

        return Font(family: family, name: name, weight: weight, size: size)
    }
}

private extension String {

    // MARK: - Type Properties

    static let fontFamilyCodingKey = "family"
    static let fontNameCodingKey = "name"
    static let fontWeightCodingKey = "weight"
    static let fontSizeCodingKey = "size"
}
