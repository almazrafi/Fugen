import Foundation
import SwiftCLI
import PromiseKit
import FugenTools

final class ColorsCommand: Command {

    // MARK: - Instance Properties

    let name = "colors"
    let shortDescription = "Generates code for colors from a Figma file."

    let fileKey = Key<String>(
        "--fileKey",
        description: """
            Figma file key to generate colors from.
            """
    )

    let accessToken = Key<String>(
        "--accessToken",
        description: """
            A personal access token to make requests to the Figma API.
            Get more info: https://www.figma.com/developers/api#access-tokens
            """
    )

    let excludingNodeIDs = Key<String>(
        "--excluding",
        description: """
            Comma separated list of nodes to be excluded.
            """
    )

    let includingNodeIDs = Key<String>(
        "--including",
        description: """
            Comma separated list of nodes to be included.
            """
    )

    let destinationPath = Key<String>(
        "--destinationPath",
        "-d",
        description: """
             The path to the file to generate.
             By default, generated code will be printed on stdout.
             """
    )

    let services: ColorsServices

    // MARK: - Initializers

    init(services: ColorsServices) {
        self.services = services
    }

    // MARK: - Instance Methods

    func execute() throws {
        guard let fileKey = fileKey.value, !fileKey.isEmpty else {
            fail(message: "Fatal error: Figma file key is missing or empty.")
        }

        guard let accessToken = accessToken.value, !accessToken.isEmpty else {
            fail(message: "Fatal error: Figma access token is missing or empty.")
        }

        let includingNodeIDs = self.includingNodeIDs.value?.components(separatedBy: ",") ?? []
        let excludingNodeIDs = self.excludingNodeIDs.value?.components(separatedBy: ",") ?? []

        let colorsProvider = services.makeColorsProvider(accessToken: accessToken)

        firstly {
            colorsProvider.fetchColors(
                fileKey: fileKey,
                excludingNodes: excludingNodeIDs,
                includingNodes: includingNodeIDs
            )
        }.done { colors in
            // TODO: implement template rendering

            self.success(message: "Color generation completed successfully: \(String(reflecting: colors))")
        }.catch { error in
            self.fail(error: error)
        }

        RunLoop.main.run()
    }
}
