import Foundation

public enum DictionaryNonConformingFloatDecodingStrategy {

    // MARK: - Enumeration Cases

    case `throw`
    case convertFromString(positiveInfinity: String, negativeInfinity: String, nan: String)
}
