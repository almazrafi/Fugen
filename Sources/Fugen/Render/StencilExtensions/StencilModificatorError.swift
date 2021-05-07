import Foundation

struct StencilModificatorError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case invalidValue(_ value: Any?)
        case invalidArguments(_ argument: [Any?])
    }

    // MARK: - Instance Properties

    let code: Code
    let filter: String

    // MARK: - Instance Properties

    var description: String {
        switch code {
        case let .invalidValue(value):
            let valueDescription = value.map(String.init(describing:)) ?? "nil"

            return "Stencil filter '\(filter)' cannot be used for value: \(valueDescription)"

        case let .invalidArguments(arguments):
            let argumentDescriptions = arguments.compactMap { $0 }.map(String.init(describing:))

            return "Stencil filter '\(filter)' was called with an invalid arguments: \(argumentDescriptions)"
        }
    }
}
