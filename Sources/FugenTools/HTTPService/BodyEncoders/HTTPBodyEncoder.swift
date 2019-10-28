import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol HTTPBodyEncoder {

    // MARK: - Instance Methods

    func encode<T: Encodable>(request: URLRequest, parameters: T) throws -> URLRequest
}
