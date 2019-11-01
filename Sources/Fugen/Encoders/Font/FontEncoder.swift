import Foundation

protocol FontEncoder {

    // MARK: - Instance Methods

    func encodeFont(_ font: Font) -> [String: Any]
}
