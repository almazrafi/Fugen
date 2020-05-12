import Foundation
import SwiftCLI
import PathKit

#if DEBUG
Path.current = Path(#file).appending("../../../Demo")
#endif

let version = "1.0.3"

let fugen = CLI(
    name: "fugen",
    version: version,
    description: "The Swift code & resources generator for your Figma files"
)

fugen.commands = [
    ColorStylesCommand(generator: Dependencies.colorStylesGenerator),
    TextStylesCommand(generator: Dependencies.textStylesGenerator),
    ImagesCommand(generator: Dependencies.imagesGenerator),
    GenerateCommand(generator: Dependencies.libraryGenerator)
]

fugen.goAndExitOnError()
