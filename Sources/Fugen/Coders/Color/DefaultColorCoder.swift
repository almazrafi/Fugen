import Foundation

final class DefaultColorCoder: ColorCoder {

    // MARK: - Instance Methods

    func encodeColor(_ color: Color) -> [String: Any] {
        return [
            .redComponentCodingKey: color.red,
            .greenComponentCodingKey: color.green,
            .blueComponentCodingKey: color.blue,
            .alphaComponentCodingKey: color.alpha
        ]
    }

    func decodeColor(from encodedColor: [String: Any]) -> Color? {
        guard let red = encodedColor[.redComponentCodingKey] as? Double else {
            return nil
        }

        guard let green = encodedColor[.greenComponentCodingKey] as? Double else {
            return nil
        }

        guard let blue = encodedColor[.blueComponentCodingKey] as? Double else {
            return nil
        }

        guard let alpha = encodedColor[.alphaComponentCodingKey] as? Double else {
            return nil
        }

        return Color(red: red, green: green, blue: blue, alpha: alpha)
    }
}

private extension String {

    // MARK: - Type Properties

    static let redComponentCodingKey = "red"
    static let greenComponentCodingKey = "green"
    static let blueComponentCodingKey = "blue"
    static let alphaComponentCodingKey = "alpha"
}
