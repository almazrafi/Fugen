import Foundation

internal class DictionaryKeyedDecodingContainer<Key: CodingKey>:
    KeyedDecodingContainerProtocol,
    DictionaryComponentDecoder {

    // MARK: - Instance Properties

    internal let components: [String: Any]
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal var allKeys: [Key] {
        components.keys.compactMap { Key(stringValue: $0) }
    }

    // MARK: - Initializers

    internal init(
        components: [String: Any],
        options: DictionaryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.components = components
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath

        // TODO: transfrom key with keyDecodingStrategy
    }

    // MARK: - Instance Methods

    private func component<T>(of type: T.Type = T.self, forKey key: Key) throws -> T {
        let anyComponent = components[key.stringValue]

        guard let component = anyComponent as? T else {
            throw DecodingError.invalidComponent(anyComponent, forKey: key, at: codingPath, expectation: type)
        }

        return component
    }

    private func superDecoder(forAnyKey key: CodingKey) throws -> Decoder {
        let decoder = DictionarySingleValueDecodingContainer(
            component: components[key.stringValue],
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        return decoder
    }

    // MARK: -

    internal func contains(_ key: Key) -> Bool {
        return components.contains { $0.key == key.stringValue }
    }

    internal func decodeNil(forKey key: Key) throws -> Bool {
        decodeNilComponent(try component(forKey: key))
    }

    internal func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int8.Type, forKey key: Key) throws -> Int8 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int16.Type, forKey key: Key) throws -> Int16 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int32.Type, forKey key: Key) throws -> Int32 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Int64.Type, forKey key: Key) throws -> Int64 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt.Type, forKey key: Key) throws -> UInt {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt8.Type, forKey key: Key) throws -> UInt8 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt16.Type, forKey key: Key) throws -> UInt16 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt32.Type, forKey key: Key) throws -> UInt32 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: UInt64.Type, forKey key: Key) throws -> UInt64 {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: Float.Type, forKey key: Key) throws -> Float {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode(_ type: String.Type, forKey key: Key) throws -> String {
        try decodeComponentValue(try component(forKey: key))
    }

    internal func decode<T: Decodable>(_ type: T.Type, forKey key: Key) throws -> T {
        try decodeComponentValue(try component(forKey: key), as: type)
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) throws -> KeyedDecodingContainer<NestedKey> {
        return try superDecoder(forAnyKey: key).container(keyedBy: keyType)
    }

    internal func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        return try superDecoder(forAnyKey: key).unkeyedContainer()
    }

    internal func superDecoder(forKey key: Key) throws -> Decoder {
        return try superDecoder(forAnyKey: key)
    }

    internal func superDecoder() throws -> Decoder {
        return try superDecoder(forAnyKey: AnyCodingKey.super)
    }
}

private extension DecodingError {

    // MARK: - Type Methods

    static func invalidComponent<Key: CodingKey>(
        _ component: Any?,
        forKey key: Key,
        at codingPath: [CodingKey],
        expectation: Any.Type
    ) -> DecodingError {
        switch component {
        case let component?:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "Expected to decode \(expectation) but found \(type(of: component)) instead."
            )

            return .typeMismatch(expectation, context)

        case nil:
            let context = Context(
                codingPath: codingPath,
                debugDescription: "No value associated with key \(key.stringValue)."
            )

            return .keyNotFound(key, context)
        }
    }
}

private extension AnyCodingKey {

    // MARK: - Type Properties

    static let `super` = AnyCodingKey("super")
}
