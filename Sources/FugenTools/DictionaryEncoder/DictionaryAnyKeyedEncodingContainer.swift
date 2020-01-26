import Foundation

internal final class DictionaryAnyKeyedEncodingContainer: DictionaryComponentContainer {

    // MARK: - Instance Properties

    private var componets: [String: DictionaryComponent] = [:]

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

    private func encodeKey<Key: CodingKey>(_ key: Key) -> String {
        switch options.keyEncodingStrategy {
        case .useDefaultKeys:
            return key.stringValue

        case let .custom(closure):
            return closure(codingPath.appending(key)).stringValue
        }
    }

    // MARK: -

    internal func collectComponent<Key: CodingKey>(_ component: DictionaryComponent, forKey key: Key) {
        componets[encodeKey(key)] = component
    }

    internal func nestedContainer<Key: CodingKey, NestedKey: CodingKey>(
        keyedBy keyType: NestedKey.Type,
        forKey key: Key
    ) -> DictionaryAnyKeyedEncodingContainer {
        if case let .container(container as DictionaryAnyKeyedEncodingContainer) = componets[encodeKey(key)] {
            return container
        }

        let container = DictionaryAnyKeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectComponent(.container(container), forKey: key)

        return container
    }

    internal func nestedUnkeyedContainer<Key: CodingKey>(forKey key: Key) -> UnkeyedEncodingContainer {
        if case let .container(container as DictionaryUnkeyedEncodingContainer) = componets[encodeKey(key)] {
            return container
        }

        let container = DictionaryUnkeyedEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectComponent(.container(container), forKey: key)

        return container
    }

    internal func superEncoder<Key: CodingKey>(forKey key: Key) -> Encoder {
        if case let .container(container as DictionarySingleValueEncodingContainer) = componets[encodeKey(key)] {
            return container
        }

        let encoder = DictionarySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath.appending(key)
        )

        collectComponent(.container(encoder), forKey: key)

        return encoder
    }

    // MARK: - DictionaryComponentContainer

    internal func resolveValue() -> Any? {
        return componets.compactMapValues { $0.resolveValue() }
    }
}
