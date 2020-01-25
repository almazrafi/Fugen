import Foundation

internal struct DictionaryEncodingOptions {

    // MARK: - Instance Properties

    internal let dateEncodingStrategy: DictionaryDateEncodingStrategy
    internal let dataEncodingStrategy: DictionaryDataEncodingStrategy
    internal let nonConformingFloatEncodingStrategy: DictionaryNonConformingFloatEncodingStrategy
    internal let keyEncodingStrategy: DictionaryKeyEncodingStrategy

    // MARK: - Initializers

    internal init(
        dateEncodingStrategy: DictionaryDateEncodingStrategy,
        dataEncodingStrategy: DictionaryDataEncodingStrategy,
        nonConformingFloatEncodingStrategy: DictionaryNonConformingFloatEncodingStrategy,
        keyEncodingStrategy: DictionaryKeyEncodingStrategy
    ) {
        self.dateEncodingStrategy = dateEncodingStrategy
        self.dataEncodingStrategy = dataEncodingStrategy
        self.nonConformingFloatEncodingStrategy = nonConformingFloatEncodingStrategy
        self.keyEncodingStrategy = keyEncodingStrategy
    }
}
