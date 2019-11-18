import Foundation

protocol ColorStylesCoder {

    // MARK: - Instance Methods

    func encodeColorStyle(_ colorStyle: ColorStyle) -> [String: Any]
    func encodeColorStyles(_ colorStyles: [ColorStyle]) -> [String: Any]
}
