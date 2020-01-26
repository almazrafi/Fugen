import Foundation

public final class DictionaryDecoder {

    // MARK: - Type Properties

    public static let `default` = DictionaryDecoder()

    // MARK: - Instance Properties

    public var dateDecodingStrategy: DictionaryDateDecodingStrategy
    public var dataDecodingStrategy: DictionaryDataDecodingStrategy
    public var nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy
    public var keyDecodingStrategy: DictionaryKeyDecodingStrategy
    public var userInfo: [CodingUserInfoKey: Any]

    // MARK: - Initializers

    public init(
        dateDecodingStrategy: DictionaryDateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: DictionaryDataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: DictionaryKeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.userInfo = userInfo
    }

    // MARK: - Instance Methods

    public func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T {
        let options = DictionaryDecodingOptions(
            dateDecodingStrategy: dateDecodingStrategy,
            dataDecodingStrategy: dataDecodingStrategy,
            nonConformingFloatDecodingStrategy: nonConformingFloatDecodingStrategy,
            keyDecodingStrategy: keyDecodingStrategy
        )

        let decoder = DictionarySingleValueDecodingContainer(
            component: dictionary,
            options: options,
            userInfo: userInfo,
            codingPath: []
        )

        return try T(from: decoder)
    }

    public func decode<T: Decodable>(from dictionary: [String: Any]) throws -> T {
        try decode(T.self, from: dictionary)
    }
}
