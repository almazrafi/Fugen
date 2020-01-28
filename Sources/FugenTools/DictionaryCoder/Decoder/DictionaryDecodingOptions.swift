import Foundation

internal struct DictionaryDecodingOptions {

    // MARK: - Instance Properties

    internal let dateDecodingStrategy: DictionaryDateDecodingStrategy
    internal let dataDecodingStrategy: DictionaryDataDecodingStrategy
    internal let nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy
    internal let keyDecodingStrategy: DictionaryKeyDecodingStrategy

    // MARK: - Initializers

    internal init(
        dateDecodingStrategy: DictionaryDateDecodingStrategy,
        dataDecodingStrategy: DictionaryDataDecodingStrategy,
        nonConformingFloatDecodingStrategy: DictionaryNonConformingFloatDecodingStrategy,
        keyDecodingStrategy: DictionaryKeyDecodingStrategy
    ) {
        self.dateDecodingStrategy = dateDecodingStrategy
        self.dataDecodingStrategy = dataDecodingStrategy
        self.nonConformingFloatDecodingStrategy = nonConformingFloatDecodingStrategy
        self.keyDecodingStrategy = keyDecodingStrategy
    }
}
