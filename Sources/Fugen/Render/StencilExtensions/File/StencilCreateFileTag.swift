import Foundation
import FugenTools
import Stencil
import PathKit

final class StencilCreateFileTag: StencilTag {

    // MARK: - Instance Properties

    let name = "createFile"

    // MARK: - Instance Methods

    private func createFile(
        at pathVariable: Variable,
        withContent contentVariable: Variable,
        context: Context
    ) throws -> String {
        guard let relativePath = try pathVariable.resolve(context) as? String else {
            throw StencilTagError(
                code: .invalidVariable(pathVariable.variable, expectedType: String.self),
                tag: name
            )
        }

        guard let content = try contentVariable.resolve(context) as? String else {
            throw StencilTagError(
                code: .invalidVariable(contentVariable.variable, expectedType: String.self),
                tag: name
            )
        }

        let filePath = Path.current.appending(relativePath)

        try filePath.parent().mkpath()
        try filePath.write(content)

        return .empty
    }

    func makeNode(parser: TokenParser, token: Token) throws -> NodeType {
        let arguments = token.components()
        let pathArgument: String
        let contentArgument: String

        switch arguments.count {
        case 5 where arguments[1] == .createFilePathLabel && arguments[3] == .createFileContentLabel:
            pathArgument = arguments[2]
            contentArgument = arguments[4]

        case 4 where arguments[2] == .createFileContentLabel:
            pathArgument = arguments[1]
            contentArgument = arguments[3]

        default:
            throw StencilTagError(code: .invalidArguments(arguments), tag: name)
        }

        return StencilTagNode(token: token) { context in
            try self.createFile(
                at: Variable(pathArgument),
                withContent: Variable(contentArgument),
                context: context
            )
        }
    }
}

private extension String {

    // MARK: - Type Properties

    static let createFilePathLabel = "at"
    static let createFileContentLabel = "withContent"
}
