import Foundation

public protocol HTTPQueryEncoder {

    // MARK: - Instance Methods

    func encode<T: Encodable>(url: URL, parameters: T) throws -> URL
}
