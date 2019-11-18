import Foundation
import Stencil

final class StencilColorExtension: StencilExtension {

    // MARK: - Instance Properties

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    private func extractColor(from value: Any?, filter: String) throws -> Color {
        guard let encodedColor = value as? [String: Any] else {
            throw StencilExtensionError.invalidFilterValue(value, filter: filter)
        }

        guard let color = colorCoder.decodeColor(from: encodedColor) else {
            throw StencilExtensionError.invalidFilterValue(value, filter: filter)
        }

        return color
    }

    private func colorRGBHexInfo(from value: Any?) throws -> String? {
        return try extractColor(from: value, filter: .stencilColorRGBHexInfoFilter).rgbHexInfo
    }

    private func colorRGBAHexInfo(from value: Any?) throws -> String? {
        return try extractColor(from: value, filter: .stencilColorRGBAHexInfoFilter).rgbaHexInfo
    }

    private func colorRGBInfo(from value: Any?) throws -> String? {
        return try extractColor(from: value, filter: .stencilColorRGBInfoFilter).rgbInfo
    }

    private func colorRGBAInfo(from value: Any?) throws -> String? {
        return try extractColor(from: value, filter: .stencilColorRGBAInfoFilter).rgbaInfo
    }

    private func colorInfo(from value: Any?) throws -> String? {
        let color = try extractColor(from: value, filter: .stencilColorInfoFilter)

        return "Hex \(color.rgbaHexInfo); rgba \(color.rgbaInfo)"
    }

    // MARK: -

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(.stencilColorRGBHexInfoFilter, filter: colorRGBHexInfo)
        extensionRegistry.registerFilter(.stencilColorRGBAHexInfoFilter, filter: colorRGBAHexInfo)

        extensionRegistry.registerFilter(.stencilColorRGBInfoFilter, filter: colorRGBInfo)
        extensionRegistry.registerFilter(.stencilColorRGBAInfoFilter, filter: colorRGBAInfo)

        extensionRegistry.registerFilter(.stencilColorInfoFilter, filter: colorInfo)
    }
}

private extension Color {

    // MARK: - Instance Properties

    var rgbHexInfo: String {
        "#\(red.colorComponentHexByte)\(green.colorComponentHexByte)\(blue.colorComponentHexByte)"
    }

    var rgbaHexInfo: String {
        "\(rgbHexInfo)\(alpha.colorComponentHexByte)"
    }

    var rgbInfo: String {
        "\(red.colorComponentByte) \(green.colorComponentByte) \(blue.colorComponentByte)"
    }

    var rgbaInfo: String {
        "\(rgbInfo), \(Int(alpha * 100.0))%"
    }
}

private extension String {

    // MARK: - Type Properties

    static let stencilColorRGBHexInfoFilter = "colorRGBHexInfo"
    static let stencilColorRGBAHexInfoFilter = "colorRGBAHexInfo"

    static let stencilColorRGBInfoFilter = "colorRGBInfo"
    static let stencilColorRGBAInfoFilter = "colorRGBAInfo"

    static let stencilColorInfoFilter = "colorInfo"
}

private extension Double {

    // MARK: - Instance Properties

    var colorComponentByte: Int {
        Int(self * 255.0)
    }

    var colorComponentHexByte: String {
        String(format: "%02lX", colorComponentByte)
    }
}
