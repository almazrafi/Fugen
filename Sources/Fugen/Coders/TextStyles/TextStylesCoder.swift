import Foundation

protocol TextStylesCoder {

    // MARK: - Instance Methods

    func encodeTextStyle(_ textStyle: TextStyle) -> [String: Any]
    func encodeTextStyles(_ textStyles: [TextStyle]) -> [String: Any]
}
