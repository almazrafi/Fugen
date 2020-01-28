import Foundation

internal final class DictionaryUnkeyedEncodingContainer:
    UnkeyedEncodingContainer,
    DictionaryComponentContainer,
    DictionaryComponentEncoder {

    // MARK: - Instance Properties

    private var components: [DictionaryComponent] = []

    internal let options: DictionaryEncodingOptions
    internal let userInfo: [CodingUserInfoKey: Any]
    internal let codingPath: [CodingKey]

    internal var count: Int {
        components.count
    }

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

    private func collectComponent(_ component: DictionaryComponent) {
        components.append(component)
    }

    // MARK: - UnkeyedEncodingContainer

    internal func encodeNil() throws {
        collectComponent(encodeNilComponent())
    }

    internal func encode(_ value: Bool) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Int) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Int8) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Int16) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Int32) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Int64) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: UInt) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: UInt8) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: UInt16) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: UInt32) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: UInt64) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode(_ value: Double) throws {
        collectComponent(try encodeComponentValue(value))
    }

    internal func encode(_ value: Float) throws {
        collectComponent(try encodeComponentValue(value))
    }

    internal func encode(_ value: String) throws {
        collectComponent(encodeComponentValue(value))
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        collectComponent(try encodeComponentValue(value))
    }

    internal func nestedContainer<NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type
    ) -> KeyedEncodingContainer<NestedKey> {
        let container = DictionaryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )

        collectComponent(.container(container))

        return KeyedEncodingContainer(
            DictionaryKeyedEncodingContainer<NestedKey>(container: container)
        )
    }

    internal func nestedUnkeyedContainer() -> UnkeyedEncodingContainer {
        let container = DictionaryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )

        collectComponent(.container(container))

        return container
    }

    internal func superEncoder() -> Encoder {
        let encoder = DictionarySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(AnyCodingKey(count))
        )

        collectComponent(.container(encoder))

        return encoder
    }

    // MARK: - DictionaryComponentContainer

    internal func resolveValue() -> Any? {
        return components.map { $0.resolveValue() }
    }
}
