import Foundation
import SwiftCLI
import PromiseKit

let fugen = CLI(
    name: "fugen",
    version: "1.0.0",
    description: "A tool to automate resources using the Figma API."
)

fugen.goAndExit()
