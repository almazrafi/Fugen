import Foundation
import Stencil
import StencilSwiftKit
import PathKit

final class DefaultTemplateRenderer: TemplateRenderer {

    // MARK: - Instance Properties

    let contextCoder: TemplateContextCoder
    let stencilExtensions: [StencilExtension]

    // MARK: - Initializers

    init(contextCoder: TemplateContextCoder, stencilExtensions: [StencilExtension]) {
        self.contextCoder = contextCoder
        self.stencilExtensions = stencilExtensions
    }

    // MARK: - Instance Methods

    private func resolveTemplatePath(of templateType: RenderTemplateType) throws -> Path {
        switch templateType {
        case let .native(name: templateName):
            let templateFileName = templateName.appending(String.templatesFileExtension)

            #if DEBUG
            let xcodeTemplatesPath = Path.current.appending(.templatesXcodeRelativePath)

            if xcodeTemplatesPath.exists {
                return xcodeTemplatesPath.appending(templateFileName)
            }
            #endif

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

    func renderTemplate<Context: Encodable>(
        _ template: RenderTemplate,
        to destination: RenderDestination,
        context: Context
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

        let templateContext = try contextCoder
            .encode(context)
            .merging([.templateOptionsKey: template.options]) { $1 }

        let output = try stencilTemplate.render(templateContext)

        try writeOutput(output, to: destination)
    }
}

private extension String {

    // MARK: - Type Properties

    static let templatesFileExtension = ".stencil"
    static let templatesXcodeRelativePath = "../Templates"
    static let templatesPodsRelativePath = "../Templates"
    static let templatesShareRelativePath = "../../share/fugen"
    static let templateOptionsKey = "options"
}
