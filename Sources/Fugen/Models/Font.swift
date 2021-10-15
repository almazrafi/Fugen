import Foundation

struct Font: Codable, Hashable {

    // MARK: - Instance Properties

    let family: String
    let name: String
    let weight: Double
    let size: Double
}

extension Font {

    // MARK: - Instance Properties

    var isSystemFont: Bool {
        name.contains(String.textSystemFontName) || name.contains(String.displaySystemFontName)
    }
}

private extension String {

    // MARK: - Type Properties

    static let textSystemFontName = "SFProText"
    static let displaySystemFontName = "SFProDisplay"
}
