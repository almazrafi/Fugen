import Foundation

internal final class DictionarySingleValueEncodingContainer:
    Encoder,
    SingleValueEncodingContainer,
    DictionaryComponentContainer,
    DictionaryComponentEncoder {

    // MARK: - Instance Properties

    private var component: DictionaryComponent?

    internal let options: DictionaryEncodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    // MARK: - Initializers

    internal init(
        options: DictionaryEncodingOptions,
        userInfo: [CodingUserInfoKey: Any],
        codingPath: [CodingKey]
    ) {
        self.options = options
        self.userInfo = userInfo
        self.codingPath = codingPath
    }

    // MARK: - Instance Methods

    private func collectComponent(_ component: DictionaryComponent, for value: Any?) throws {
        guard self.component == nil else {
            let errorContext = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Single value container already has encoded value"
            )

            throw EncodingError.invalidValue(value as Any, errorContext)
        }

        self.component = component
    }

    // MARK: - SingleValueEncodingContainer

    internal func encodeNil() throws {
        try collectComponent(encodeNilComponent(), for: nil)
    }

    internal func encode(_ value: Bool) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Int) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Int8) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Int16) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Int32) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Int64) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: UInt) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: UInt8) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: UInt16) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: UInt32) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: UInt64) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Double) throws {
        try collectComponent(try encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: Float) throws {
        try collectComponent(try encodeComponentValue(value), for: value)
    }

    internal func encode(_ value: String) throws {
        try collectComponent(encodeComponentValue(value), for: value)
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        try collectComponent(try encodeComponentValue(value), for: value)
    }

    // MARK: - Encoder

    internal func container<Key: CodingKey>(keyedBy keyType: Key.Type) -> KeyedEncodingContainer<Key> {
        if case let .container(container as DictionaryAnyKeyedEncodingContainer) = component {
            return KeyedEncodingContainer(
                DictionaryKeyedEncodingContainer<Key>(container: container)
            )
        }

        let container = DictionaryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        component = .container(container)

        return KeyedEncodingContainer(
            DictionaryKeyedEncodingContainer<Key>(container: container)
        )
    }

    internal func unkeyedContainer() -> UnkeyedEncodingContainer {
        if case let .container(container as DictionaryUnkeyedEncodingContainer) = component {
            return container
        }

        let container = DictionaryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        component = .container(container)

        return container
    }

    internal func singleValueContainer() -> SingleValueEncodingContainer {
        self
    }

    // MARK: - DictionaryComponentContainer

    internal func resolveValue() -> Any? {
        return component?.resolveValue()
    }
}
