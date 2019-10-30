import Foundation

protocol ColorsDependencies {

    // MARK: - Instance Methods

    func makeColorsProvider() -> ColorsProvider
    func makeColorsRenderer() -> ColorsRenderer
}
