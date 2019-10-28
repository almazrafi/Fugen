import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol HTTPErrorStringConvertible {

    // MARK: - Instance Properties

    var httpErrorDescription: String { get }
}

// MARK: -

extension URLError: HTTPErrorStringConvertible {

    // MARK: - Instance Properties

    public var httpErrorDescription: String {
        return "\(String(describing: type(of: self))).\(self.code.rawValue)"
    }
}
