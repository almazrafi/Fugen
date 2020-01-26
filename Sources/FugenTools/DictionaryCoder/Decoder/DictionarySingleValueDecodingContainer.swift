import Foundation

internal final class DictionarySingleValueDecodingContainer:
    Decoder,
    SingleValueDecodingContainer,
    DictionaryComponentDecoder {

    // MARK: - Instance Properties

    internal let component: Any?
    internal let options: DictionaryDecodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    // MARK: - Initializers

    internal init(
        component: Any?,
        options: DictionaryDecodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.component = component
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    // MARK: - Instance Methods

    internal func decodeNil() -> Bool {
        return decodeNilComponent(component)
    }

    internal func decode(_ type: Bool.Type) throws -> Bool {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Int.Type) throws -> Int {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Int8.Type) throws -> Int8 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Int16.Type) throws -> Int16 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Int32.Type) throws -> Int32 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Int64.Type) throws -> Int64 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: UInt.Type) throws -> UInt {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: UInt8.Type) throws -> UInt8 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: UInt16.Type) throws -> UInt16 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: UInt32.Type) throws -> UInt32 {
         return try decodeComponentValue(component)
    }

    internal func decode(_ type: UInt64.Type) throws -> UInt64 {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Double.Type) throws -> Double {
        return try decodeComponentValue(component)
    }

    internal func decode(_ type: Float.Type) throws -> Float {
         return try decodeComponentValue(component)
    }

    internal func decode(_ type: String.Type) throws -> String {
        return try decodeComponentValue(component)
    }

    internal func decode<T: Decodable>(_ type: T.Type) throws -> T {
        return try decodeComponentValue(component, as: type)
    }

    // MARK: - Decoder

    internal func container<Key: CodingKey>(keyedBy keyType: Key.Type) throws -> KeyedDecodingContainer<Key> {
        guard let components = component as? [String: Any] else {
            throw DecodingError.keyedContainerTypeMismatch(at: codingPath, component: component)
        }

        let container = DictionaryKeyedDecodingContainer<Key>(
            components: components,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        return KeyedDecodingContainer(container)
    }

    internal func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        guard let components = component as? [Any?] else {
            throw DecodingError.unkeyedContainerTypeMismatch(at: codingPath, component: component)
        }

        return DictionaryUnkeyedDecodingContainer(
            components: components,
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )
    }

    internal func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }
}
