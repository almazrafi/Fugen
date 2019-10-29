import Foundation

protocol ColorsServices {

    // MARK: - Instance Methods

    func makeColorsProvider(accessToken: String) -> ColorsProvider
}
