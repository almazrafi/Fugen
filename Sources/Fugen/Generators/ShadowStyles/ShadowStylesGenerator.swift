import Foundation
import PromiseKit

protocol ShadowStylesGenerator {

    // MARK: - Instance Methods

    func generate(configuration: ShadowStylesConfiguration) -> Promise<Void>
}
