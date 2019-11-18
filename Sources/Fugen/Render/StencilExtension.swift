import Foundation
import Stencil

typealias ExtensionRegistry = Extension

protocol StencilExtension {

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry)
}
