import Foundation

public enum DictionaryKeyDecodingStrategy {

    // MARK: - Enumeration Cases

    case useDefaultKeys
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
}
