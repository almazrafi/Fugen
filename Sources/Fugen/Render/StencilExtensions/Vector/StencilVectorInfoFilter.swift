import Foundation

final class StencilVectorInfoFilter: StencilVectorFilter {

    // MARK: - Nested Types

    typealias VectorFilterOutput = String

    // MARK: - Instance Properties

    let name = "vectorInfo"

    let contextCoder: TemplateContextCoder

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder) {
        self.contextCoder = contextCoder
    }

    // MARK: - Instance Methods

    func filter(vector: Vector) throws -> String {
        return "x \(vector.x); y \(vector.y)"
    }
}
