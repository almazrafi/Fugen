import Foundation
import SwiftCLI
import PromiseKit

final class ImagesCommand: AsyncExecutableCommand, GenerationConfigurableCommand {

    // MARK: - Instance Properties

    let generator: ImagesGenerator

    // MARK: -

    let name = "images"
    let shortDescription = "Generates code for images from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate images from.
            """
    )

    let fileVersion = Key<String>(
        "--fileVersion",
        description: """
            Figma file version ID to generate images from.
            """
    )

    let includedNodes = VariadicKey<String>(
        "--includingNodes",
        "-i",
        description: #"""
            A list of Figma nodes whose styles will be extracted.
            Can be repeated multiple times and must be in the format: -i "1:23".
            If omitted, all nodes will be included.
            """#
    )

    let excludedNodes = VariadicKey<String>(
        "--excludingNodes",
        "-e",
        description: #"""
            A list of Figma nodes whose styles will be ignored.
            Can be repeated multiple times and must be in the format: -e "1:23".
            """#
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let assets = Key<String>(
        "--assets",
        "-a",
        description: """
            Optional path to Xcode-assets folder to store images.
            """
    )

    let resources = Key<String>(
        "--resources",
        "-r",
        description: """
            Optional path to Xcode-assets folder to store images.
            """
    )

    let format = Key<String>(
        "--format",
        "-r",
        description: """
            Optional image output format, can be 'pdf', 'png', 'jpg' or 'svg'.
            Defaults to 'pdf'.
            """
    )

    let scales = Key<String>(
        "-scales",
        "-s",
        description: #"""
            A comma separated list of integer image scaling factors.
            Each scaling factor should be between 1 and 4: -s "1,2,3".
            If omitted, images will be rendered with the original sizes.
            """#
    )

    let template = Key<String>(
        "--template",
        "-t",
        description: """
            Path to the template file.
            If no template is passed a default template will be used.
            """
    )

    let templateOptions = VariadicKey<String>(
        "--options",
        "-o",
        description: #"""
            An option that will be merged with template context, and overwrite any values of the same name.
            Can be repeated multiple times and must be in the format: -o "name:value".
            """#
    )

    let destination = Key<String>(
        "--destination",
        "-d",
        description: """
            The path to the file to generate.
            By default, generated code will be printed on stdout.
            """
    )

    // MARK: - Initializers

    init(generator: ImagesGenerator) {
        self.generator = generator
    }

    // MARK: - Instance Methods

    private func resolveImagesConfiguration() -> ImagesConfiguration {
        let format: ImageFormat

        switch self.format.value {
        case "pdf", nil:
            format = .pdf

        case "png":
            format = .png

        case "jpg":
            format = .jpg

        case "svg":
            format = .svg

        default:
            self.fail(message: "Failed to generate images: Invalid format (\(String(describing: self.format.value)))")
        }

        let scales: [ImageScale] = self.scales.value?.components(separatedBy: ",").map { scale in
            switch scale {
            case "1":
                return .scale1x

            case "2":
                return .scale2x

            case "3":
                return .scale3x

            case "4":
                return .scale4x

            default:
                self.fail(message: "Failed to generate images: Invalid scaling factor (\(String(describing: scale)))")
            }
        } ?? [.single]

        return ImagesConfiguration(
            generatation: generationConfiguration,
            assets: assets.value,
            resources: resources.value,
            format: format,
            scales: scales
        )
    }

    // MARK: -

    func executeAsyncAndExit() throws {
        firstly {
            self.generator.generate(configuration: self.resolveImagesConfiguration())
        }.done {
            self.succeed(message: "Color styles generated successfully!")
        }.catch { error in
            self.fail(message: "Failed to generate images: \(error)")
        }
    }
}
