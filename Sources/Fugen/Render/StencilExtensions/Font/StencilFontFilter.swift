import Foundation

protocol StencilFontFilter: StencilFilter where Input == [String: Any] {

    // MARK: - Instance Properties

    var fontCoder: FontCoder { get }

    // MARK: - Instance Methods

    func filter(font: Font) throws -> Output
}

extension StencilFontFilter {

    // MARK: - Instance Methods

    func filter(input: [String: Any]) throws -> Output {
        guard let font = fontCoder.decodeFont(from: input) else {
            throw StencilFilterError.invalidValue(input, filter: name)
        }

        return try filter(font: font)
    }
}
