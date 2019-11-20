import Foundation
import Stencil

protocol StencilFilter: StencilExtension {

    // MARK: - Nested Types

    associatedtype Input
    associatedtype Output

    // MARK: - Instance Methods

    func filter(input: Input) throws -> Output
}

extension StencilFilter {

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerFilter(name) { value in
            guard let input = value as? Input else {
                throw StencilFilterError(code: .invalidValue(value), filter: self.name)
            }

            return try self.filter(input: input)
        }
    }
}
