import Foundation

final class StencilHexToByteFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "hexToByte"

    // MARK: - Instance Methods

    func filter(input: String) throws -> UInt8 {
        guard let number = Int(input, radix: 16), 0...255 ~= number else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        return UInt8(number)
    }
}
