import Foundation

class StencilFloatToByteFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "floatToByte"

    // MARK: - Instance Methods

    func filter(input: Double) throws -> UInt8 {
        guard 0.0...1.0 ~= input else {
            throw StencilFilterError.invalidValue(input, filter: name)
        }

        return UInt8(input * 255.0)
    }
}
