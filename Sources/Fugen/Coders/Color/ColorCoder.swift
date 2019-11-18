import Foundation

protocol ColorCoder {

    // MARK: - Instance Methods

    func encodeColor(_ color: Color) -> [String: Any]
    func decodeColor(from encodedColor: [String: Any]) -> Color?
}
