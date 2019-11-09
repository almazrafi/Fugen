import Foundation
import PromiseKit

protocol TextStylesGenerator {

    // MARK: - Instance Methods

    func generate(configuration: TextStylesConfiguration) -> Promise<Void>
}
