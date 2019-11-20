import Foundation

protocol StencilColorFilter: StencilFilter where Input == [String: Any], Output == ColorFilterOutput {

    // MARK: - Nested Types

    associatedtype ColorFilterOutput

    // MARK: - Instance Properties

    var colorCoder: ColorCoder { get }

    // MARK: - Instance Methods

    func colorComponentHexByte(_ component: Double) -> String?
    func colorComponentByte(_ component: Double) -> UInt8?

    func filter(color: Color) throws -> ColorFilterOutput
}

extension StencilColorFilter {

    // MARK: - Instance Methods

    func colorComponentByte(_ component: Double) -> UInt8? {
        let floatToByteFilter = StencilFloatToByteFilter()

        return try? floatToByteFilter.filter(input: component)
    }

    func colorComponentHexByte(_ component: Double) -> String? {
        guard let component = colorComponentByte(component) else {
            return nil
        }

        let byteToHexFilter = StencilByteToHexFilter()

        return byteToHexFilter.filter(input: component)
    }

    func filter(input: [String: Any]) throws -> ColorFilterOutput {
        guard let color = colorCoder.decodeColor(from: input) else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        return try filter(color: color)
    }
}
