import Foundation

enum StencilExtensionError: Error, CustomStringConvertible {

    // MARK: - Enumaration Cases

    case invalidFilterValue(_ value: Any?, filter: String)
    case invalidFilterArgument(_ argument: Any?, filter: String)

    // MARK: - Instance Properties

    var description: String {
        switch self {
        case let .invalidFilterValue(value, filter):
            return "Stencil filter '\(filter)' cannot be used for value: \(String(describing: value))"

        case let .invalidFilterArgument(argument, filter):
            return "Stencil filter '\(filter)' was called with an invalid argument: \(String(describing: argument))"
        }
    }
}
