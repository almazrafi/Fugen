import Foundation

public enum DictionaryDataEncodingStrategy {

    // MARK: - Enumeration Cases

    case deferredToData
    case base64
    case custom((_ data: Data, _ encoder: Encoder) throws -> Void)
}
