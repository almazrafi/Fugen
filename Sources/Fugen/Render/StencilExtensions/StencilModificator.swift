import Foundation
import FugenTools

protocol StencilModificator: StencilExtension {

    // MARK: - Nested Types

    associatedtype Input
    associatedtype Output

    // MARK: - Instance Methods

    func modify(input: Input, withArguments arguments: [Any?]) throws -> Output
}

extension StencilModificator {

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(name) { value, parameters in
            guard let input = value as? Input else {
                throw StencilModificatorError(code: .invalidValue(value), filter: name)
            }

            return try self.modify(input: input, withArguments: parameters)
        }
    }
}
