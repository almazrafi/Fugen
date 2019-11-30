import Foundation

protocol ImagesCoder {

    // MARK: - Instance Methods

    func encodeImage(_ image: Image) -> [String: Any]
    func encodeImages(_ images: [Image]) -> [String: Any]
}
