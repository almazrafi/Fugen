import Foundation

struct StencilFilterError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    enum Code {
        case invalidValue(_ value: Any?)
        case invalidArgument(_ argument: Any?)
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

        case let .invalidArgument(argument):
            let argumentDescription = argument.map(String.init(describing:)) ?? "nil"

            return "Stencil filter '\(filter)' was called with an invalid argument: \(argumentDescription)"
        }
    }
}
