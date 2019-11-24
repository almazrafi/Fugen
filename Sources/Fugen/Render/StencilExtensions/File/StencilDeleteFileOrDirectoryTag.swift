import Foundation
import FugenTools
import Stencil
import PathKit

final class StencilDeleteFileOrDirectoryTag: StencilTag {

    // MARK: - Instance Properties

    let name = "deleteFileOrDirectory"

    // MARK: - Instance Methods

    private func deleteFileOrDirectory(at pathVariable: Variable, context: Context) throws -> String {
        guard let relativePath = try pathVariable.resolve(context) as? String else {
            throw StencilTagError(
                code: .invalidVariable(pathVariable.variable, expectedType: String.self),
                tag: name
            )
        }

        let filePath = Path.current.appending(relativePath)

        if filePath.exists {
            try filePath.delete()
        }

        return .empty
    }

    func makeNode(parser: TokenParser, token: Token) throws -> NodeType {
        let arguments = token.components()
        let pathArgument: String

        switch arguments.count {
        case 3 where arguments[1] == .deleteFileOrDirectoryPathLabel:
            pathArgument = arguments[2]

        case 2:
            pathArgument = arguments[1]

        default:
            throw StencilTagError(code: .invalidArguments(arguments), tag: name)
        }

        return StencilTagNode(token: token) { context in
            try self.deleteFileOrDirectory(at: Variable(pathArgument), context: context)
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let deleteFileOrDirectoryPathLabel = "at"
}
