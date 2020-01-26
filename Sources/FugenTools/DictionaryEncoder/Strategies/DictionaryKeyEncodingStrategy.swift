import Foundation

public enum DictionaryKeyEncodingStrategy {

    // MARK: - Enumeration Cases

    case useDefaultKeys
    case custom((_ codingPath: [CodingKey]) -> CodingKey)
}
