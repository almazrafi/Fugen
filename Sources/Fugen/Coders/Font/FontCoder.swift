import Foundation

protocol FontCoder {

    // MARK: - Instance Methods

    func encodeFont(_ font: Font) -> [String: Any]
    func decodeFont(from encodedFont: [String: Any]) -> Font?
}
