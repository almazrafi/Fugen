import Foundation
import PromiseKit

protocol LibraryGenerator {

    // MARK: - Instance Methods

    func generate(configurationPath: String) -> Promise<Void>
}
