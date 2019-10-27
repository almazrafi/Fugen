import Foundation

internal struct HTTPAnyEncodable: Encodable {

    // MARK: - Instance Properties

    internal let value: Encodable

    // MARK: - Initializers

    internal init(_ value: Encodable) {
        self.value = value
    }

    // MARK: - Instance Methods

    internal func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}
