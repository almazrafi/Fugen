import Foundation

final class DefaultColorCoder: ColorCoder {

    // MARK: - Instance Methods

    func encodeColor(_ color: Color) -> [String: Any] {
        return [
            .colorRedCodingKey: color.red,
            .colorGreenCodingKey: color.green,
            .colorBlueCodingKey: color.blue,
            .colorAlphaCodingKey: color.alpha
        ]
    }

    func decodeColor(from encodedColor: [String: Any]) -> Color? {
        guard let red = encodedColor[.colorRedCodingKey] as? Double else {
            return nil
        }

        guard let green = encodedColor[.colorGreenCodingKey] as? Double else {
            return nil
        }

        guard let blue = encodedColor[.colorBlueCodingKey] as? Double else {
            return nil
        }

        guard let alpha = encodedColor[.colorAlphaCodingKey] as? Double else {
            return nil
        }

        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
}

private extension String {

    // MARK: - Type Properties

    static let colorRedCodingKey = "red"
    static let colorGreenCodingKey = "green"
    static let colorBlueCodingKey = "blue"
    static let colorAlphaCodingKey = "alpha"
}
