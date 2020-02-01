import Foundation

extension Decodable {

    public init<Key: CodingKey>(from decoder: Decoder, forKey key: Key) throws {
        let container = try decoder.container(keyedBy: Key.self)

        try self.init(from: try container.superDecoder(forKey: key))
    }
}
