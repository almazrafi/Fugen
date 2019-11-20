import Foundation
import FugenTools
import Stencil
import PathKit

final class StencilDeleteFileOrDirectoryTag: StencilTag {

    // MARK: - Instance Properties

    let name = "deleteFileOrDirectory"

    // MARK: - Instance Methods

    private func deleteFileOrDirectory(_ pathVariable: Variable, context: Context) throws -> String {
        guard let relativePath = try pathVariable.resolve(context) as? String else {
            throw StencilTagError(
                code: .invalidVariable(pathVariable.variable, expectedType: String.self),
                tag: name
            )
        }

        let path = Path.current.appending(relativePath)

        if path.exists {
            try path.delete()
        }

        return .empty
    }

    func makeNode(parser: TokenParser, token: Token) throws -> NodeType {
        let arguments = token.components()
        let pathArgument: String

        switch arguments.count {
        case 3 where arguments[0] == name && arguments[1] == .deleteFileOrDirectoryAtLabel:
            pathArgument = arguments[2]

        case 2 where arguments[0] == name:
            pathArgument = arguments[1]

        default:
            throw StencilTagError(code: .invalidArguments(arguments), tag: name)
        }

        return StencilTagNode(token: token) { context in
            try self.deleteFileOrDirectory(Variable(pathArgument), context: context)
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let deleteFileOrDirectoryAtLabel = "at"
}
