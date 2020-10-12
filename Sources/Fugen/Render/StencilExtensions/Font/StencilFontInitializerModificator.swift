import Foundation

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

final class StencilFontInitializerModificator: StencilFontModificator {

    // MARK: - Type Properties

    private static let validWeights = [
        "ultraLight",
        "thin",
        "light",
        "regular",
        "medium",
        "semibold",
        "bold",
        "heavy",
        "black"
    ]

    // MARK: - Instance Properties

    let name = "initializer"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    private func validatedWeight(rawWeight: String?) -> String? {
        guard let rawWeight = rawWeight?.lowercased() else {
            return nil
        }

        return Self.validWeights.first(where: { rawWeight == $0 })
    }

    // MARK: -

    func modify(font: Font, withArguments arguments: [Any?]) throws -> String {
        guard font.isSystemFont, try parseBool(from: arguments, at: .usingSystemFontArgument) else {
            return "(name: \"\(font.name)\", size: \(font.size))"
        }

        let weight = validatedWeight(rawWeight: font.name.components(separatedBy: "-").last) ?? .defaultWeight

        return ".systemFont(ofSize: \(font.size), weight: .\(weight))"
    }
}

private extension String {

    // MARK: - Type Properties

    static let defaultWeight = "regular"
}

private extension Int {

    // MARK: - Type Properties

    static let usingSystemFontArgument = 0
}
