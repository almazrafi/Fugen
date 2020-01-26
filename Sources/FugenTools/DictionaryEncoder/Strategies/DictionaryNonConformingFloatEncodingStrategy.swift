import Foundation

public enum DictionaryNonConformingFloatEncodingStrategy {

    // MARK: - Enumeration Cases

    case `throw`
    case convertToString(positiveInfinity: String, negativeInfinity: String, nan: String)
}
