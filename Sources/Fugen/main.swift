import Foundation
import SwiftCLI
import FugenTools

let dependencies = Dependencies()

let fugen = CLI(
    name: "fugen",
    version: "1.0.0",
    description: "A tool to automate resources using the Figma API."
)

let colorStylesGenerator = ColorStylesGenerator(
    colorStylesProvider: dependencies.makeColorStylesProvider(),
    colorStylesEncoder: dependencies.makeColorStylesEncoder(),
    templateRenderer: dependencies.makeTemplateRenderer()
)

let makeTextStylesGenerator = TextStylesGenerator (
    textStylesProvider: dependencies.makeTextStylesProvider(),
    textStylesEncoder: dependencies.makeTextStylesEncoder(),
    templateRenderer: dependencies.makeTemplateRenderer()
)

fugen.commands = [
    ColorStylesCommand(generator: colorStylesGenerator),
    TextStylesCommand(generator: makeTextStylesGenerator)
]

fugen.goAndExitOnError()
