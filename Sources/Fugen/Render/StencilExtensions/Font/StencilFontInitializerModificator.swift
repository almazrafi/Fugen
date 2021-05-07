import Foundation

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

        return Self.validWeights.first { rawWeight == $0 }
    }

    private func usingSystemFonts(from arguments: [Any?]) throws -> Bool {
        guard let usingSystemFonts = arguments.first else {
            throw StencilModificatorError(code: .invalidArguments(arguments), filter: name)
        }

        return usingSystemFonts as? Bool ?? false
    }

    // MARK: -

    func modify(font: Font, withArguments arguments: [Any?]) throws -> String {
        guard font.isSystemFont, try usingSystemFonts(from: arguments) else {
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
