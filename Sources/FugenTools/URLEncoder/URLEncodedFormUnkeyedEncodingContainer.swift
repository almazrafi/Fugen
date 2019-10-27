import Foundation

internal final class URLEncodedFormUnkeyedEncodingContainer: UnkeyedEncodingContainer {

    // MARK: - Instance Properties

    internal let context: URLEncodedFormContext
    internal let boolEncodingStrategy: URLBoolEncodingStrategy
    internal let dateEncodingStrategy: URLDateEncodingStrategy

    // MARK: - UnkeyedEncodingContainer

    internal var codingPath: [CodingKey]
    internal var count = 0

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

    internal func encodeNil() throws {
        let errorContext = EncodingError.Context(
            codingPath: codingPath,
            debugDescription: "Nil values cannot be encoded in URL"
        )

        throw EncodingError.invalidValue("nil", errorContext)
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        defer {
            count += 1
        }

        let container = URLEncodedFormSingleValueEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )

        try container.encode(value)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        defer {
            count += 1
        }

        let container = URLEncodedFormKeyedEncodingContainer<NestedKey>(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )

        return KeyedEncodingContainer(container)
    }

    internal func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        defer {
            count += 1
        }

        return URLEncodedFormUnkeyedEncodingContainer(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )
    }

    internal func superEncoder() -> Encoder {
        defer {
            count += 1
        }

        return URLEncodedFormEncoder(
            context: context,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy,
            codingPath: codingPath
        )
    }
}
