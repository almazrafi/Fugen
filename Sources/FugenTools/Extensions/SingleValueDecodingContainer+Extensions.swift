import Foundation

extension SingleValueDecodingContainer {

    // MARK: - Instance Methods

    public func decode<T: Decodable>() throws -> T {
        return try decode(T.self)
    }
}
