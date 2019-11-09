import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: StepConfiguration?

    let colorStyles: StepConfiguration?
    let textStyles: StepConfiguration?

    // MARK: - Instance Methods

    func resolveColorStyles() -> StepConfiguration? {
        return colorStyles?.resolve(baseConfiguration: base)
    }

    func resolveTextStyles() -> StepConfiguration? {
        return textStyles?.resolve(baseConfiguration: base)
    }
}
