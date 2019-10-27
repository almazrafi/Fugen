import Foundation

extension UnkeyedDecodingContainer {

    // MARK: - Instance Methods

    public mutating func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }

    public mutating func decodeIfPresent<T: Decodable>() throws -> T? {
        return try decodeIfPresent(T.self)
    }
}
