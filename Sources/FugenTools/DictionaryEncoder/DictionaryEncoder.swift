import Foundation

public final class DictionaryEncoder {

    // MARK: - Type Properties

    public static let `default` = DictionaryEncoder()

    // MARK: - Instance Properties

    public var dateEncodingStrategy: DictionaryDateEncodingStrategy
    public var dataEncodingStrategy: DictionaryDataEncodingStrategy
    public var nonConformingFloatEncodingStrategy: DictionaryNonConformingFloatEncodingStrategy
    public var keyEncodingStrategy: DictionaryKeyEncodingStrategy
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: - Initializers

    public init(
        dateEncodingStrategy: DictionaryDateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: DictionaryDataEncodingStrategy = .base64,
        nonConformingFloatEncodingStrategy: DictionaryNonConformingFloatEncodingStrategy = .throw,
        keyEncodingStrategy: DictionaryKeyEncodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.dataEncodingStrategy = dataEncodingStrategy
        self.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        self.keyEncodingStrategy = keyEncodingStrategy
        self.userInfo = userInfo
    }

    // MARK: - Instance Methods

    public func encode<T: Encodable>(_ value: T) throws -> [String: Any] {
        let options = DictionaryEncodingOptions(
            dateEncodingStrategy: dateEncodingStrategy,
            dataEncodingStrategy: dataEncodingStrategy,
            nonConformingFloatEncodingStrategy: nonConformingFloatEncodingStrategy,
            keyEncodingStrategy: keyEncodingStrategy
        )

        let encoder = DictionarySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        try value.encode(to: encoder)

        guard let dictionary = encoder.resolveValue() as? [String: Any] else {
            let errorContext = EncodingError.Context(
                codingPath: [],
                debugDescription: "Root component cannot be encoded in Dictionary"
            )

            throw EncodingError.invalidValue(value, errorContext)
        }

        return dictionary
    }
}
