import Foundation

final class DefaultColorEncoder: ColorEncoder {

    // MARK: - Instance Methods

    private func encodeColorComponent(_ colorComponent: Double) -> String {
        return String(format: "%02lX", Int(colorComponent * 255.0))
    }

    // MARK: - ColorEncoder

    func encodeColor(_ color: Color) -> [String: Any] {
        return [
            "red": encodeColorComponent(color.red),
            "green": encodeColorComponent(color.green),
            "blue": encodeColorComponent(color.blue),
            "alpha": encodeColorComponent(color.alpha)
        ]
    }
}
