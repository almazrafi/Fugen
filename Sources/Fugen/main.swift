import Foundation
import SwiftCLI
import FugenTools

let dependencies = Dependencies()

let fugen = CLI(
    name: "fugen",
    version: "1.0.0-alpha.1",
    description: "A tool to generate code from Figma files"
)

fugen.commands = [
    ColorStylesCommand(generator: dependencies.makeColorStylesGenerator()),
    TextStylesCommand(generator: dependencies.makeTextStylesGenerator()),
    GenerateCommand(generator: dependencies.makeKitGenerator())
]

fugen.goAndExitOnError()
