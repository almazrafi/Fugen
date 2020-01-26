import Foundation

internal indirect enum DictionaryComponent {

    // MARK: - Enumeration Cases

    case value(Any?)
    case container(DictionaryComponentContainer)

    // MARK: - Instance Methods

    internal func resolveValue() -> Any? {
        switch self {
        case .value(let value):
            return value

        case .container(let container):
            return container.resolveValue()
        }
    }
}
