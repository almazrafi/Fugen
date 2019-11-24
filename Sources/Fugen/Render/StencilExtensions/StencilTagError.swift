import Foundation

struct StencilTagError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case invalidArguments(_ arguments: [String])
        case invalidVariable(_ variable: String, expectedType: Any.Type)
    }
    // MARK: - Enumeration Cases

    let code: Code
    let tag: String

    // MARK: - Instance Properties

    var description: String {
        switch code {
        case let .invalidArguments(arguments):
            return "Stencil tag '\(tag)' received an invalid argument list: \(arguments)"

        case let .invalidVariable(variable, expectedType):
            return "Stencil variable '\(variable)' cannot be resolved as \(expectedType) for tag '\(tag)'"
        }
    }
}
