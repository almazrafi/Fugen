import Foundation

protocol StencilFontModificator: StencilModificator where Input == [String: Any], Output == FontModificatorOutput {

    // MARK: - Nested Types

    associatedtype FontModificatorOutput

    // MARK: - Instance Properties

    var contextCoder: TemplateContextCoder { get }

    // MARK: - Instance Methods

    func modify(font: Font, withArguments arguments: [Any?]) throws -> FontModificatorOutput
}

extension StencilFontModificator {

    // MARK: - Instance Methods

    func modify(input: [String: Any], withArguments arguments: [Any?]) throws -> FontModificatorOutput {
        guard let font = try? contextCoder.decode(Font.self, from: input) else {
            throw StencilModificatorError(code: .invalidValue(input), filter: name)
        }

        return try modify(font: font, withArguments: arguments)
    }
}
