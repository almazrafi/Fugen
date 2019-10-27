import Foundation

internal final class URLEncodedFormKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol {

    // MARK: - Instance Properties

    internal let context: URLEncodedFormContext
    internal let boolEncodingStrategy: URLBoolEncodingStrategy
    internal let dateEncodingStrategy: URLDateEncodingStrategy

    // MARK: - KeyedEncodingContainerProtocol

    internal var codingPath: [CodingKey]

    // MARK: - Initializers

    internal init(
        context: URLEncodedFormContext,
        boolEncodingStrategy: URLBoolEncodingStrategy,
        dateEncodingStrategy: URLDateEncodingStrategy,
        codingPath: [CodingKey]
    ) {
        self.context = context
        self.boolEncodingStrategy = boolEncodingStrategy
        self.dateEncodingStrategy = dateEncodingStrategy
        self.codingPath = codingPath
    }

    // MARK: - Instance Methods

    internal func encodeNil(forKey key: Key) throws {
        let errorContext = EncodingError.Context(
            codingPath: codingPath,
            debugDescription: "Nil values cannot be encoded in URL"
        )

        throw EncodingError.invalidValue("nil", errorContext)
    }

    internal func encode<T: Encodable>(_ value: T, forKey key: Key) throws {
        let container = URLEncodedFormSingleValueEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(key)
        )

        try container.encode(value)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> KeyedEncodingContainer<NestedKey> {
        let container = URLEncodedFormKeyedEncodingContainer<NestedKey>(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(key)
        )

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) -> UnkeyedEncodingContainer {
        return URLEncodedFormUnkeyedEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(key)
        )
    }

    internal func superEncoder() -> Encoder {
        return URLEncodedFormEncoder(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath
        )
    }

    internal func superEncoder(forKey key: Key) -> Encoder {
        return URLEncodedFormEncoder(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(key)
        )
    }
}
