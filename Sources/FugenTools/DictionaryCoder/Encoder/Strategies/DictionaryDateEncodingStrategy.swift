import Foundation

public enum DictionaryDateEncodingStrategy {

    // MARK: - Enumeration Cases

    case deferredToDate

    case millisecondsSince1970
    case secondsSince1970

    @available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)
    case iso8601

    case formatted(DateFormatter)
    case custom((_ date: Date, _ encoder: Encoder) throws -> Void)
}
