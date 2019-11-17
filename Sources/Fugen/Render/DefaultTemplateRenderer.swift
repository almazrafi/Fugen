import Foundation
import Stencil
import StencilSwiftKit
import PathKit

final class DefaultTemplateRenderer: TemplateRenderer {

    // MARK: - Instance Properties

    let stencilExtensions: [StencilExtension]

    // MARK: - Initializers

    init(stencilExtensions: [StencilExtension]) {
        self.stencilExtensions = stencilExtensions
    }

    // MARK: - Instance Methods

    private func resolveTemplatePath(of templateType: RenderTemplateType) throws -> Path {
        switch templateType {
        case let .native(name: templateName):
            let templateFileName = templateName.appending(String.templatesFileExtension)
            let projectTemplatesPath = Path(#file).appending(.templatesFileRelativePath)

            if projectTemplatesPath.exists {
                return projectTemplatesPath.appending(templateFileName)
            }

            var executablePath = Path(ProcessInfo.processInfo.executablePath)

            while executablePath.isSymlink {
                executablePath = try executablePath.symlinkDestination()
            }

            let podsTemplatesPath = executablePath.appending(.templatesPodsRelativePath)

            if podsTemplatesPath.exists {
                return podsTemplatesPath.appending(templateFileName)
            }

            return executablePath
                .appending(.templatesShareRelativePath)
                .appending(templateFileName)

        case let .custom(path: templatePath):
            return Path(templatePath)
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

    // MARK: -

    func renderTemplate(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: [String: Any]
    ) throws {
        let stencilExtensionRegistry = ExtensionRegistry()

        stencilExtensionRegistry.registerStencilSwiftExtensions()

        stencilExtensions.forEach { stencilExtension in
            stencilExtension.register(in: stencilExtensionRegistry)
        }

        let templatePath = try resolveTemplatePath(of: template.type)

        let stencilEnvironment = Environment(
            loader: FileSystemLoader(paths: [templatePath.parent()]),
            extensions: [stencilExtensionRegistry],
            templateClass: StencilSwiftTemplate.self
        )

        let stencilTemplate = StencilSwiftTemplate(
            templateString: try templatePath.read(),
            environment: stencilEnvironment
        )

        let context = context.merging([.templateOptionsKey: template.options]) { $1 }
        let output = try stencilTemplate.render(context)

        try writeOutput(output, to: destination)
    }
}

private extension String {

    // MARK: - Type Properties

    static let templatesFileExtension = ".stencil"
    static let templatesFileRelativePath = "../../../../Templates"
    static let templatesPodsRelativePath = "../Templates"
    static let templatesShareRelativePath = "../../share/fugen"
    static let templateOptionsKey = "options"
}
