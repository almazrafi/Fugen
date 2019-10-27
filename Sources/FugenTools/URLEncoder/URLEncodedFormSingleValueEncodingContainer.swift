import Foundation

internal final class URLEncodedFormSingleValueEncodingContainer: SingleValueEncodingContainer {

    // MARK: - Instance Properties

    private var canEncodeNextValue = true

    // MARK: -

    internal let context: URLEncodedFormContext
    internal let boolEncodingStrategy: URLBoolEncodingStrategy
    internal let dateEncodingStrategy: URLDateEncodingStrategy

    // MARK: - SingleValueEncodingContainer

    internal var codingPath: [CodingKey]

    // MARK: - Initializers

    internal init(
        context: URLEncodedFormContext,
        boolEncodingStrategy: URLBoolEncodingStrategy,
        dateEncodingStrategy: URLDateEncodingStrategy,
        codingPath: [CodingKey]
    ) {
        self.context = context
        self.boolEncodingStrategy = boolEncodingStrategy
        self.dateEncodingStrategy = dateEncodingStrategy
        self.codingPath = codingPath
    }

    // MARK: - Instance Methods

    private func markAsEncoded(_ value: Any?) throws {
        guard canEncodeNextValue else {
            let errorContext = EncodingError.Context(
                codingPath: codingPath,
                debugDescription: "Single value container has already encoded value"
            )

            throw EncodingError.invalidValue(value as Any, errorContext)
        }

        canEncodeNextValue = false
    }

    private func updatedComponent(
        _ component: URLEncodedFormComponent,
        with value: URLEncodedFormComponent,
        at path: [CodingKey]
    ) -> URLEncodedFormComponent {
        guard let pathKey = path.first else {
            return value
        }

        var child: URLEncodedFormComponent

        switch path.count {
        case 1:
            child = value

        default:
            if let index = pathKey.intValue {
                let array = component.array ?? []

                if index < array.count {
                    child = updatedComponent(array[index], with: value, at: Array(path[1...]))
                } else {
                    child = updatedComponent(.array([]), with: value, at: Array(path[1...]))
                }
            } else {
                child = updatedComponent(
                    component.dictionary?[pathKey.stringValue] ?? .dictionary([:]),
                    with: value,
                    at: Array(path[1...])
                )
            }
        }

        if let childIndex = pathKey.intValue {
            guard var array = component.array else {
                return .array([child])
            }

            if childIndex < array.count {
                array[childIndex] = child
            } else {
                array.append(child)
            }

            return .array(array)
        } else {
            guard var dictionary = component.dictionary else {
                return .dictionary([pathKey.stringValue: child])
            }

            dictionary[pathKey.stringValue] = child

            return .dictionary(dictionary)
        }
    }

    private func encode<T: Encodable>(_ value: T, as string: String) throws {
        try markAsEncoded(value)

        context.component = updatedComponent(context.component, with: .string(string), at: codingPath)
    }

    private func encode(_ date: Date) throws {
        switch dateEncodingStrategy {
        case .deferredToDate:
            try markAsEncoded(date)

            let encoder = URLEncodedFormEncoder(
                context: context,
                boolEncodingStrategy: boolEncodingStrategy,
                dateEncodingStrategy: dateEncodingStrategy,
                codingPath: codingPath
            )

            try date.encode(to: encoder)

        case .millisecondsSince1970:
            try encode(date, as: String(date.timeIntervalSince1970 * 1000.0))

        case .secondsSince1970:
            try encode(date, as: String(date.timeIntervalSince1970))

        case .iso8601:
            guard #available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *) else {
                fatalError("ISO8601DateFormatter is unavailable on this platform.")
            }

            let formattedDate = ISO8601DateFormatter.string(
                from: date,
                timeZone: Contants.iso8601TimeZone,
                formatOptions: .withInternetDateTime
            )

            try encode(date, as: formattedDate)

        case let .formatted(dateFormatter):
            try encode(date, as: dateFormatter.string(from: date))

        case let .custom(closure):
            try encode(date, as: try closure(date))
        }
    }

    // MARK: - SingleValueEncodingContainer

    internal func encodeNil() throws {
        try markAsEncoded(nil)

        let errorContext = EncodingError.Context(
            codingPath: codingPath,
            debugDescription: "Nil values cannot be encoded in URL"
        )

        throw EncodingError.invalidValue("nil", errorContext)
    }

    internal func encode(_ value: Bool) throws {
        switch boolEncodingStrategy {
        case .numeric:
            try encode(value, as: value ? Contants.numericTrue : Contants.numericFalse)

        case .literal:
            try encode(value, as: value ? Contants.literalTrue : Contants.literalFalse)
        }
    }

    internal func encode(_ value: String) throws {
        try encode(value, as: value)
    }

    internal func encode(_ value: Double) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Float) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Int) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Int8) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Int16) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Int32) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: Int64) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: UInt) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: UInt8) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: UInt16) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: UInt32) throws {
        try encode(value, as: String(value))
    }

    internal func encode(_ value: UInt64) throws {
        try encode(value, as: String(value))
    }

    internal func encode<T: Encodable>(_ value: T) throws {
        switch value {
        case let date as Date:
            try encode(date)

        default:
            try markAsEncoded(value)

            let encoder = URLEncodedFormEncoder(
                context: context,
                boolEncodingStrategy: boolEncodingStrategy,
                dateEncodingStrategy: dateEncodingStrategy,
                codingPath: codingPath
            )

            try value.encode(to: encoder)
        }
    }
}

private enum Contants {

    // MARK: - Type Properties

    static let numericTrue = "1"
    static let numericFalse = "0"

    static let literalTrue = "true"
    static let literalFalse = "false"

    static let iso8601TimeZone = TimeZone(secondsFromGMT: 0)!
}
