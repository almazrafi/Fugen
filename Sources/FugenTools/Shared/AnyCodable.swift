import Foundation

public struct AnyCodable: Codable {

    // MARK: - Instance Properties

    public let value: Any

    // MARK: - Initializers

    public init<T>(_ value: T?) {
        self.value = value as Any
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.init(nil as Any?)
        } else {
            let string = try? container.decode(String.self)

            if let bool = try? container.decode(Bool.self) {
                if let string = string, string != String(describing: bool) {
                    self.init(string)
                } else {
                    self.init(bool)
                }
            } else if let int = try? container.decode(Int.self) {
                if let string = string, string != String(describing: int) {
                    self.init(string)
                } else {
                    self.init(int)
                }
            } else if let uint = try? container.decode(UInt.self) {
                if let string = string, string != String(describing: uint) {
                    self.init(string)
                } else {
                    self.init(uint)
                }
            } else if let double = try? container.decode(Double.self) {
                if let string = string, string != String(describing: double) {
                    self.init(string)
                } else {
                    self.init(double)
                }
            } else if let string = string {
                self.init(string)
            } else if let array = try? container.decode([AnyCodable].self) {
                self.init(array.map { $0.value })
            } else if let dictionary = try? container.decode([String: AnyCodable].self) {
                self.init(dictionary.mapValues { $0.value })
            } else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "AnyCodable value cannot be decoded"
                )
            }
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        // swiftlint:disable:previous function_body_length

        var container = encoder.singleValueContainer()

        switch value {
        case nil as Any?:
            try container.encodeNil()

        case let bool as Bool:
            try container.encode(bool)

        case let int as Int:
            try container.encode(int)

        case let int8 as Int8:
            try container.encode(int8)

        case let int16 as Int16:
            try container.encode(int16)

        case let int32 as Int32:
            try container.encode(int32)

        case let int64 as Int64:
            try container.encode(int64)

        case let uint as UInt:
            try container.encode(uint)

        case let uint8 as UInt8:
            try container.encode(uint8)

        case let uint16 as UInt16:
            try container.encode(uint16)

        case let uint32 as UInt32:
            try container.encode(uint32)

        case let uint64 as UInt64:
            try container.encode(uint64)

        case let float as Float:
            try container.encode(float)

        case let double as Double:
            try container.encode(double)

        case let string as String:
            try container.encode(string)

        case let date as Date:
            try container.encode(date)

        case let url as URL:
            try container.encode(url.absoluteString)

        case let array as [Any?]:
            try container.encode(array.map(AnyCodable.init))

        case let dictionary as [String: Any?]:
            try container.encode(dictionary.mapValues(AnyCodable.init))

        default:
            let context = EncodingError.Context(
                codingPath: container.codingPath,
                debugDescription: "AnyCodable value cannot be encoded"
            )

            throw EncodingError.invalidValue(value, context)
        }
    }
}

extension AnyCodable: Equatable {

    // MARK: - Type Methods

    public static func == (lhs: AnyCodable, rhs: AnyCodable) -> Bool {
        // swiftlint:disable:previous function_body_length

        switch (lhs.value, rhs.value) {
        case (nil as Any?, nil as Any?):
            return true

        case let (lhs as Bool, rhs as Bool):
            return lhs == rhs

        case let (lhs as Int, rhs as Int):
            return lhs == rhs

        case let (lhs as Int8, rhs as Int8):
            return lhs == rhs

        case let (lhs as Int16, rhs as Int16):
            return lhs == rhs

        case let (lhs as Int32, rhs as Int32):
            return lhs == rhs

        case let (lhs as Int64, rhs as Int64):
            return lhs == rhs

        case let (lhs as UInt, rhs as UInt):
            return lhs == rhs

        case let (lhs as UInt8, rhs as UInt8):
            return lhs == rhs

        case let (lhs as UInt16, rhs as UInt16):
            return lhs == rhs

        case let (lhs as UInt32, rhs as UInt32):
            return lhs == rhs

        case let (lhs as UInt64, rhs as UInt64):
            return lhs == rhs

        case let (lhs as Float, rhs as Float):
            return lhs == rhs

        case let (lhs as Double, rhs as Double):
            return lhs == rhs

        case let (lhs as String, rhs as String):
            return lhs == rhs

        case let (lhs as Date, rhs as Date):
            return lhs == rhs

        case let (lhs as URL, rhs as URL):
            return lhs == rhs

        case let (lhs as [String: Any], rhs as [String: Any]):
            return lhs.mapValues(AnyCodable.init) == rhs.mapValues(AnyCodable.init)

        case let (lhs as [Any], rhs as [Any]):
            return lhs.map(AnyCodable.init) == rhs.map(AnyCodable.init)

        default:
            return false
        }
    }
}
