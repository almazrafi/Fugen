import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: GeneratorConfiguration?

    let colorStyles: ColorStylesConfiguration?
    let textStyles: TextStylesConfiguration?

    // MARK: - Instance Methods

    func resolveColorStyles() -> ColorStylesConfiguration? {
        return colorStyles?.resolve(base: base)
    }

    func resolveTextStyles() -> TextStylesConfiguration? {
        return textStyles?.resolve(base: base)
    }
}
