import Foundation
import Stencil

protocol StencilTag: StencilExtension {

    // MARK: - Instance Methods

    func makeNode(parser: TokenParser, token: Token) throws -> NodeType
}

extension StencilTag {

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry) {
        extensionRegistry.registerTag(name, parser: makeNode)
    }
}
