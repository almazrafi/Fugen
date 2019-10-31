import Foundation
import Stencil
import StencilSwiftKit
import PathKit

final class DefaultTemplateRenderer: TemplateRenderer {

    // MARK: - Instance Methods

    private func resolveTemplatePath(of templateType: RenderTemplateType) throws -> String {
        switch templateType {
        case let .native(name: templateName):
            let templateFileName = templateName.appending(String.templatesFileExtension)
            let projectTemplatesPath = Path(#file).appending(.templatesProjectRelativePath)

            if projectTemplatesPath.exists {
                return projectTemplatesPath.appending(templateFileName).string
            }

            var executablePath = Path(ProcessInfo.processInfo.executablePath)

            while executablePath.isSymlink {
                executablePath = try executablePath.symlinkDestination()
            }

            let podsTemplatesPath = executablePath.appending(.templatesPodsRelativePath)

            if podsTemplatesPath.exists {
                return podsTemplatesPath.appending(templateFileName).string
            }

            return executablePath
                .appending(.templatesShareRelativePath)
                .appending(templateFileName)
                .string

        case let .custom(path: templatePath):
            return templatePath
        }
    }

    private func writeOutput(_ output: String, to destination: RenderDestination) throws {
        switch destination {
        case let .file(path: filePath):
            let filePath = Path(filePath)

            try filePath.parent().mkpath()
            try filePath.write(output)

        case .console:
            print(output)
        }
    }

    // MARK: - RenderService

    func renderTemplate(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: [String: Any]
    ) throws {
        let templatePath = Path(try resolveTemplatePath(of: template.type))

        let stencilTemplate = StencilSwiftTemplate(
            templateString: try templatePath.read(),
            environment: stencilSwiftEnvironment()
        )

        let context = context.merging(["options": template.options]) { $1 }
        let output = try stencilTemplate.render(context)

        try writeOutput(output, to: destination)
    }
}

private extension String {

    // MARK: - Type Properties

    static let templatesFileExtension = ".stencil"
    static let templatesProjectRelativePath = "../../../../Templates"
    static let templatesPodsRelativePath = "../Templates"
    static let templatesShareRelativePath = "../share/fugen"
}
