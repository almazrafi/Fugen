import Foundation

extension DecodingError {

    // MARK: - Instance Methods

    internal static func keyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: Any?
    ) -> DecodingError {
        let debugDescription: String

        switch component {
        case let value?:
            debugDescription = "Expected to decode \([String: Any].self) but found \(type(of: value)) instead."

        case nil:
            debugDescription = "Cannot get keyed decoding container -- found null value instead."
        }

        return .typeMismatch([String: Any].self, Context(codingPath: codingPath, debugDescription: debugDescription))
    }

    internal static func unkeyedContainerTypeMismatch(
        at codingPath: [CodingKey],
        component: Any?
    ) -> DecodingError {
        let debugDescription: String

        switch component {
        case let value?:
            debugDescription = "Expected to decode \([Any].self) but found \(type(of: value)) instead."

        case nil:
            debugDescription = "Cannot get unkeyed decoding container -- found null value instead."
        }

        return .typeMismatch([Any].self, Context(codingPath: codingPath, debugDescription: debugDescription))
    }

    internal static func typeMismatch(
        at codingPath: [CodingKey],
        expectation: Any.Type,
        reality: Any?
    ) -> DecodingError {
        let typeDescription: String

        switch reality {
        case let value?:
            typeDescription = "\(type(of: value))"

        case nil:
            typeDescription = "nil"
        }

        let debugDescription = "Expected to decode \(expectation) but found \(typeDescription) instead."

        return .typeMismatch(expectation, Context(codingPath: codingPath, debugDescription: debugDescription))
    }
}
