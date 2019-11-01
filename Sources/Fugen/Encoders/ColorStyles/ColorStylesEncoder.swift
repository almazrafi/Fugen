import Foundation

protocol ColorStylesEncoder {

    // MARK: - Instance Methods

    func encodeColorStyle(_ colorStyle: ColorStyle) -> [String: Any]
    func encodeColorStyles(_ colorStyles: [ColorStyle]) -> [String: Any]
}
