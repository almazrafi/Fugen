import Foundation

extension JSONEncoder {

    // MARK: - Initializers

    public convenience init(
        outputFormatting: OutputFormatting = [],
        dateEncodingStrategy: DateEncodingStrategy = .deferredToDate,
        dataEncodingStrategy: DataEncodingStrategy = .base64,
        nonConformingFloatEncodingStrategy: NonConformingFloatEncodingStrategy = .throw,
        keyEncodingStrategy: KeyEncodingStrategy = .useDefaultKeys,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        self.init()

        self.outputFormatting = outputFormatting
        self.dateEncodingStrategy = dateEncodingStrategy
        self.dataEncodingStrategy = dataEncodingStrategy
        self.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        self.keyEncodingStrategy = keyEncodingStrategy
        self.userInfo = userInfo
    }
}
