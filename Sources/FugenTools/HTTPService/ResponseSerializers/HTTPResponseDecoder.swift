import Foundation

public protocol HTTPResponseDecoder {

    // MARK: - Instance Methods

    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}

// MARK: -

extension JSONDecoder: HTTPResponseDecoder { }
