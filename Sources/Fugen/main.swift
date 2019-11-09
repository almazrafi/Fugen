import Foundation
import SwiftCLI
import FugenTools

let dependencies = Dependencies()

let fugen = CLI(
    name: "fugen",
    version: "1.0.0-alpha.1",
    description: "A tool to automate resources using the Figma API."
)

let colorStylesGenerator = ColorStylesGenerator(
    colorStylesProvider: dependencies.makeColorStylesProvider(),
    colorStylesEncoder: dependencies.makeColorStylesEncoder(),
    templateRenderer: dependencies.makeTemplateRenderer()
)

let textStylesGenerator = TextStylesGenerator (
    textStylesProvider: dependencies.makeTextStylesProvider(),
    textStylesEncoder: dependencies.makeTextStylesEncoder(),
    templateRenderer: dependencies.makeTemplateRenderer()
)

let kitGenerator = KitGenerator(
    configurationProvider: dependencies.makeConfigurationProvider(),
    colorStylesGenerator: colorStylesGenerator,
    textStylesGenerator: textStylesGenerator
)

fugen.commands = [
    ColorStylesCommand(generator: colorStylesGenerator),
    TextStylesCommand(generator: textStylesGenerator),
    KitCommand(generator: kitGenerator)
]

fugen.goAndExitOnError()
