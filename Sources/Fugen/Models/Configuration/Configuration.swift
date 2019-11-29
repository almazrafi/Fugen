import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: BaseConfiguration?

    let colorStyles: ColorStylesConfiguration?
    let textStyles: TextStylesConfiguration?
    let images: ImagesConfiguration?

    // MARK: - Instance Methods

    func resolveColorStyles() -> ColorStylesConfiguration? {
        return colorStyles?.resolve(base: base)
    }

    func resolveTextStyles() -> TextStylesConfiguration? {
        return textStyles?.resolve(base: base)
    }

    func resolveImages() -> ImagesConfiguration? {
        return images?.resolve(base: base)
    }
}
