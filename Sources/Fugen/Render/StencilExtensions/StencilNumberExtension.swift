import Foundation
import Stencil

final class StencilNumberExtension: StencilExtension {

    // MARK: - Instance Methods

    private func uint8ToHex(_ value: Any?) throws -> String? {
        guard let number = value as? UInt8 else {
            throw StencilExtensionError.invalidFilterValue(value, filter: .stencilUInt8ToHexFilter)
        }

        return number.hex
    }

    private func uint8ToFloat(_ value: Any?) throws -> Float? {
        guard let number = value as? UInt8 else {
            throw StencilExtensionError.invalidFilterValue(value, filter: .stencilUInt8ToFloatFilter)
        }

        return Float(number) / Float(255.0)
    }

    private func floatToUInt8(_ value: Any?) throws -> UInt8? {
        guard let number = value as? Float, 0.0...1.0 ~= number  else {
            throw StencilExtensionError.invalidFilterValue(value, filter: .stencilFloatToUInt8Filter)
        }

        return UInt8(number * 255.0)
    }

    // MARK: -

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(.stencilUInt8ToHexFilter, filter: uint8ToHex)
        extensionRegistry.registerFilter(.stencilUInt8ToFloatFilter, filter: uint8ToFloat)
        extensionRegistry.registerFilter(.stencilFloatToUInt8Filter, filter: floatToUInt8)
    }
}

private extension String {

    // MARK: - Type Properties

    static let stencilUInt8ToHexFilter = "uint8ToHex"
    static let stencilUInt8ToFloatFilter = "uint8ToFloat"
    static let stencilFloatToUInt8Filter = "floatToUInt8"
}

private extension UInt8 {

    // MARK: - Instance Properties

    var hex: String {
        String(format: "%02lX", self)
    }
}
