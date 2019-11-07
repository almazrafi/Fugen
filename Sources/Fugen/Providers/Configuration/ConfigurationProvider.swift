import Foundation

protocol ConfigurationProvider {

    // MARK: - Instance Methods

    func fetchConfiguration(from filePath: String) throws -> Configuration
}
