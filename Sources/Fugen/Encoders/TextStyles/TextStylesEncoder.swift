import Foundation

protocol TextStylesEncoder {

    // MARK: - Instance Methods

    func encodeTextStyle(_ textStyle: TextStyle) -> [String: Any]
    func encodeTextStyles(_ textStyles: [TextStyle]) -> [String: Any]
}
