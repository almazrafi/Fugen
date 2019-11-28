import Foundation

protocol DataProvider {

    // MARK: - Instance Methods

    func fetchData(from url: URL) throws -> Data
}
