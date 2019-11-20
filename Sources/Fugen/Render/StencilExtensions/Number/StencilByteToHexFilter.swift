import Foundation

final class StencilByteToHexFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "byteToHex"

    // MARK: - Instance Methods

    func filter(input: UInt8) -> String {
        return String(format: "%02lX", input)
    }
}
