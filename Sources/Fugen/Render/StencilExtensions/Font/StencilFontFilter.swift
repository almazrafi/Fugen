import Foundation

protocol StencilFontFilter: StencilFilter where Input == [String: Any], Output == FontFilterOutput {

    // MARK: - Nested Types

    associatedtype FontFilterOutput

    // MARK: - Instance Properties

    var contextCoder: TemplateContextCoder { get }

    // MARK: - Instance Methods

    func filter(font: Font) throws -> FontFilterOutput
}

extension StencilFontFilter {

    // MARK: - Instance Methods

    func filter(input: [String: Any]) throws -> FontFilterOutput {
        guard let font = try? contextCoder.decode(Font.self, from: input) else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        return try filter(font: font)
    }
}
