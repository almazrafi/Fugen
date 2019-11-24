import Foundation
import Stencil

struct StencilTagNode: NodeType {

    // MARK: - Instance Properties

    let token: Token?
    let renderer: ((_ context: Context) throws -> String)

    // MARK: - Instance Methods

    func render(_ context: Context) throws -> String {
        return try renderer(context)
    }
}
