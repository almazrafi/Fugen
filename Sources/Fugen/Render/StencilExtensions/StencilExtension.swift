import Foundation
import Stencil

typealias ExtensionRegistry = Extension

protocol StencilExtension {

    // MARK: - Instance Properties

    var name: String { get }

    // MARK: - Instance Methods

    func register(in extensionRegistry: ExtensionRegistry)
}
