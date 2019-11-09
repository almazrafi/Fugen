import Foundation
import PromiseKit

protocol KitGenerator {

    // MARK: - Instance Methods

    func generate(configurationPath: String) -> Promise<Void>
}
