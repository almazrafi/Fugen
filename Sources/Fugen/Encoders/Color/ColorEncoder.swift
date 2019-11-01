import Foundation

protocol ColorEncoder {

    // MARK: - Instance Methods

    func encodeColor(_ color: Color) -> [String: Any]
}
