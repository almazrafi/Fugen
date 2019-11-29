import Foundation
import PromiseKit

protocol ImagesGenerator {

    // MARK: - Instance Methods

    func generate(configuration: ImagesConfiguration) -> Promise<Void>
}
