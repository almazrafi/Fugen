import Foundation

public enum DictionaryDataDecodingStrategy {

    // MARK: - Enumeration Cases

    case deferredToData
    case base64
    case custom((_ decoder: Decoder) throws -> Data)
}
