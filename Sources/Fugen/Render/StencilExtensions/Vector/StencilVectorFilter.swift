import Foundation

protocol StencilVectorFilter: StencilFilter where Input == [String: Any], Output == VectorFilterOutput {

    // MARK: - Nested Types

    associatedtype VectorFilterOutput

    // MARK: - Instance Properties

    var contextCoder: TemplateContextCoder { get }

    // MARK: - Instance Methods

    func filter(vector: Vector) throws -> VectorFilterOutput
}

extension StencilVectorFilter {

    // MARK: - Instance Methods

    func filter(input: [String: Any]) throws -> VectorFilterOutput {
        guard let vector = try? contextCoder.decode(Vector.self, from: input) else {
            throw StencilFilterError(code: .invalidValue(input), filter: name)
        }

        return try filter(vector: vector)
    }
}
