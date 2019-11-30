import Foundation
import PromiseKit

protocol DataProvider {

    // MARK: - Instance Methods

    func fetchData(from url: URL) -> Promise<Data>
    func saveData(from url: URL, to filePath: String) -> Promise<Void>
}
