import Foundation
import SwiftCLI

let version = "1.0.0-alpha.5"

let fugen = CLI(
    name: "fugen",
    version: version,
    description: "A tool to generate code from Figma files"
)

fugen.commands = [
    ColorStylesCommand(generator: Dependencies.colorStylesGenerator),
    TextStylesCommand(generator: Dependencies.textStylesGenerator),
    GenerateCommand(generator: Dependencies.kitGenerator)
]

fugen.goAndExitOnError()
