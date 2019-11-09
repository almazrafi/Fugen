import Foundation
import PromiseKit

protocol ConfigurationProvider {

    // MARK: - Instance Methods

    func fetchConfiguration(from configurationPath: String) -> Promise<Configuration>
}
