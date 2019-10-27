import Foundation

internal final class URLEncodedFormSerializer {

    // MARK: - Instance Properties

    internal let arrayEncodingStrategy: URLArrayEncodingStrategy
    internal let spaceEncodingStrategy: URLSpaceEncodingStrategy

    // MARK: - Initializers

    internal init(
        arrayEncodingStrategy: URLArrayEncodingStrategy,
        spaceEncodingStrategy: URLSpaceEncodingStrategy
    ) {
        self.arrayEncodingStrategy = arrayEncodingStrategy
        self.spaceEncodingStrategy = spaceEncodingStrategy
    }

    // MARK: - Instance Methods

    private func escapeString(_ string: String) -> String {
        var allowedCharacters = CharacterSet.urlQueryAllowed

        allowedCharacters.remove(charactersIn: Constants.delimiters)
        allowedCharacters.insert(charactersIn: Constants.space)

        let escapedString = string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? string

        switch spaceEncodingStrategy {
        case .percentEscaped:
            return escapedString.replacingOccurrences(of: Constants.space, with: Constants.percentEscapedSpace)

        case .plusReplaced:
            return escapedString.replacingOccurrences(of: Constants.space, with: Constants.plusReplacedSpace)
        }
    }

    private func serializeComponent(_ component: URLEncodedFormComponent, key: String) -> String {
        switch component {
        case let .string(value):
            return String(format: Constants.stringComponentFormat, escapeString(key), escapeString(value))

        case let .array(value):
            return value.map { element in
                switch arrayEncodingStrategy {
                case .brackets:
                    return serializeComponent(
                        element,
                        key: String(format: Constants.bracketsArrayComponentKeyFormat, key)
                    )

                case .noBrackets:
                    return serializeComponent(
                        element,
                        key: String(format: Constants.noBracketsArrayComponentKeyFormat, key)
                    )
                }
            }.joined(separator: Constants.ampersand)

        case let .dictionary(value):
            return value.map { element in
                return serializeComponent(
                    element.value,
                    key: String(format: Constants.dictionaryComponentKeyFormat, key, element.key)
                )
            }.joined(separator: Constants.ampersand)
        }
    }

    // MARK: -

    internal func serialize(_ form: URLEncodedForm) -> String {
        return form.map { element in
            return serializeComponent(element.value, key: element.key)
        }.joined(separator: Constants.ampersand)
    }
}

private enum Constants {

    // MARK: - Type Properties

    static let delimiters = ":#[]@!$&'()*+,;="
    static let ampersand = "&"
    static let space = " "

    static let percentEscapedSpace = "%20"
    static let plusReplacedSpace = "+"

    static let stringComponentFormat = "%@=%@"

    static let bracketsArrayComponentKeyFormat = "%@[]"
    static let noBracketsArrayComponentKeyFormat = "%@"

    static let dictionaryComponentKeyFormat = "%@[%@]"
}
