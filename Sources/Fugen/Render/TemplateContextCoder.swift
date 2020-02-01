import Foundation

protocol TemplateContextCoder {

    // MARK: - Instance Methods

    func decode<T: Decodable>(_ type: T.Type, from dictionary: [String: Any]) throws -> T
    func encode<T: Encodable>(_ value: T) throws -> [String: Any]
}
