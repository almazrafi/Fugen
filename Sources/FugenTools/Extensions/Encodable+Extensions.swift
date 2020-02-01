import Foundation

extension Encodable {

    public func encode<Key: CodingKey>(to encoder: Encoder, forKey key: Key) throws {
        var container = encoder.container(keyedBy: Key.self)

        try encode(to: container.superEncoder(forKey: key))
    }
}
