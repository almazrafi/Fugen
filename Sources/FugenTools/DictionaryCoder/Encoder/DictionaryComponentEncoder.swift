import Foundation

internal protocol DictionaryComponentEncoder {

    // MARK: - Instance Properties

    var options: DictionaryEncodingOptions { get }
    var userInfo: [CodingUserInfoKey: Any] { get }
    var codingPath: [CodingKey] { get }
}

extension DictionaryComponentEncoder {

    // MARK: - Instance Methods

    private func encodePrimitiveValue(_ value: Any?) -> DictionaryComponent {
        return .value(value)
    }

    private func encodeNonPrimitiveValue<T: Encodable>(_ value: T) throws -> DictionaryComponent {
        let encoder = DictionarySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        try value.encode(to: encoder)

        return .value(encoder.resolveValue())
    }

    private func encodeCustomizedValue<T: Encodable>(
        _ value: T,
        closure: (_ value: T, _ encoder: Encoder) throws -> Void
    ) throws -> DictionaryComponent {
        let encoder = DictionarySingleValueEncodingContainer(
            options: options,
            userInfo: userInfo,
            codingPath: codingPath
        )

        try closure(value, encoder)

        return .value(encoder.resolveValue())
    }

    private func encodeDate(_ date: Date) throws -> DictionaryComponent {
        switch options.dateEncodingStrategy {
        case .deferredToDate:
            return try encodeNonPrimitiveValue(date)

        case .millisecondsSince1970:
            return encodePrimitiveValue(date.timeIntervalSince1970 * 1000.0)

        case .secondsSince1970:
            return encodePrimitiveValue(date.timeIntervalSince1970)

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = ISO8601DateFormatter.string(
                from: date,
                timeZone: .iso8601TimeZone,
                formatOptions: .withInternetDateTime
            )

            return encodePrimitiveValue(formattedDate)

        case let .formatted(dateFormatter):
            return encodePrimitiveValue(dateFormatter.string(from: date))

        case let .custom(closure):
            return try encodeCustomizedValue(date, closure: closure)
        }
    }

    private func encodeData(_ data: Data) throws -> DictionaryComponent {
        switch options.dataEncodingStrategy {
        case .deferredToData:
            return try encodeNonPrimitiveValue(data)

        case .base64:
            return encodePrimitiveValue(data.base64EncodedString())

        case let .custom(closure):
            return try encodeCustomizedValue(data, closure: closure)
        }
    }

    private func encodeFloatingPoint<T: FloatingPoint & Encodable>(_ value: T) throws -> DictionaryComponent {
        if value.isFinite {
            return encodePrimitiveValue(value)
        }

        switch options.nonConformingFloatEncodingStrategy {
        case let .convertToString(positiveInfinity, _, _) where value == T.infinity:
            return encodePrimitiveValue(positiveInfinity)

        case let .convertToString(_, negativeInfinity, _) where value == -T.infinity:
            return encodePrimitiveValue(negativeInfinity)

        case let .convertToString(_, _, nan):
            return encodePrimitiveValue(nan)

        case .throw:
            throw EncodingError.invalidFloatingPointValue(value, at: codingPath)
        }
    }

    // MARK: -

    internal func encodeNilComponent() -> DictionaryComponent {
        return encodePrimitiveValue(nil)
    }

    internal func encodeComponentValue(_ value: Bool) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Int) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Int8) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Int16) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Int32) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Int64) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: UInt) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: UInt8) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: UInt16) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: UInt32) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: UInt64) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue(_ value: Double) throws -> DictionaryComponent {
        return try encodeFloatingPoint(value)
    }

    internal func encodeComponentValue(_ value: Float) throws -> DictionaryComponent {
        return try encodeFloatingPoint(value)
    }

    internal func encodeComponentValue(_ value: String) -> DictionaryComponent {
        return encodePrimitiveValue(value)
    }

    internal func encodeComponentValue<T: Encodable>(_ value: T) throws -> DictionaryComponent {
        switch value {
        case let date as Date:
            return try encodeDate(date)

        case let data as Data:
            return try encodeData(data)

        default:
            return try encodeNonPrimitiveValue(value)
        }
    }
}

private extension TimeZone {

    // MARK: - Type Properties

    static let iso8601TimeZone = TimeZone(secondsFromGMT: 0)!
}

private extension EncodingError {

    // MARK: - Type Methods

    static func invalidFloatingPointValue<T: FloatingPoint>(_ value: T, at codingPath: [CodingKey]) -> EncodingError {
        let valueDescription: String

        switch value {
        case T.infinity:
            valueDescription = "\(T.self).infinity"

        case -T.infinity:
            valueDescription = "-\(T.self).infinity"

        default:
            valueDescription = "\(T.self).nan"
        }

        let debugDescription = """
            Unable to encode \(valueDescription) directly in Dictionary.
            Use DictionaryNonConformingFloatEncodingStrategy.convertToString to specify how the value should be encoded.
            """

        return .invalidValue(value, EncodingError.Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
