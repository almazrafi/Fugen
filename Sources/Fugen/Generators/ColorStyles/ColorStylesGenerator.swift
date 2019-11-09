import Foundation
import PromiseKit

protocol ColorStylesGenerator {

    // MARK: - Instance Methods

    func generate(configuration: ColorStylesConfiguration) -> Promise<Void>
}
