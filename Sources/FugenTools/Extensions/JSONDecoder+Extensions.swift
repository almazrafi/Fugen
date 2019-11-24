import Foundation

extension JSONDecoder {

    // MARK: - Initializers

    public convenience init(
        dateDecodingStrategy: DateDecodingStrategy = .deferredToDate,
        dataDecodingStrategy: DataDecodingStrategy = .base64,
        nonConformingFloatDecodingStrategy: NonConformingFloatDecodingStrategy = .throw,
        keyDecodingStrategy: KeyDecodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.init()

        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
        self.userInfo = userInfo
    }

    // MARK: - Instance Methods

    public func decode<T: Decodable>(from data: Data) throws -> T {
        try decode(T.self, from: data)
    }
}
