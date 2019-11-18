import Foundation

enum StencilFilterError: Error, CustomStringConvertible {

    // MARK: - Enumaration Cases

    case invalidValue(_ value: Any?, filter: String)
    case invalidArgument(_ argument: Any?, filter: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidValue(value, filter):
            return "Stencil filter '\(filter)' cannot be used for value: \(String(describing: value))"

        case let .invalidArgument(argument, filter):
            return "Stencil filter '\(filter)' was called with an invalid argument: \(String(describing: argument))"
        }
    }
}
