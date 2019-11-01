import Foundation
import SwiftCLI
import FugenTools

let dependencies = Dependencies()

let fugen = CLI(
    name: "fugen",
    version: "1.0.0",
    description: "A tool to automate resources using the Figma API."
)

fugen.commands = [
    ColorStylesCommand(dependencies: dependencies)
]

fugen.goAndExitOnError()
