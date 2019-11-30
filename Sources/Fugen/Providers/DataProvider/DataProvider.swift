import Foundation
import PromiseKit

protocol DataProvider {

    // MARK: - Instance Methods

    func fetchData(from url: URL) -> Promise<Data>
}
