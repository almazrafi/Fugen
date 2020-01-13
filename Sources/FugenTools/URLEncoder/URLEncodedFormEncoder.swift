import Foundation

internal final class URLEncodedFormEncoder: Encoder {

    // MARK: - Instance Properties

    internal let context: URLEncodedFormContext
    internal let boolEncodingStrategy: URLBoolEncodingStrategy
    internal let dateEncodingStrategy: URLDateEncodingStrategy

    // MARK: - Encoder

    internal var codingPath: [CodingKey]

    internal var userInfo: [CodingUserInfoKey: Any] {
        [:]
    }

    // MARK: - Initializers

    internal init(
        context: URLEncodedFormContext,
        boolEncodingStrategy: URLBoolEncodingStrategy,
        dateEncodingStrategy: URLDateEncodingStrategy,
        codingPath: [CodingKey] = []
    ) {
        self.context = context
        self.boolEncodingStrategy = boolEncodingStrategy
        self.dateEncodingStrategy = dateEncodingStrategy
        self.codingPath = codingPath
    }

    // MARK: - Instance Methods

    internal func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        let container = URLEncodedFormKeyedEncodingContainer<Key>(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath
        )

        return KeyedEncodingContainer(container)
    }

    internal func unkeyedContainer() -> UnkeyedEncodingContainer {
        return URLEncodedFormUnkeyedEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath
        )
    }

    internal func singleValueContainer() -> SingleValueEncodingContainer {
        return URLEncodedFormSingleValueEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath
        )
    }
}
