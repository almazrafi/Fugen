import Foundation
import FugenTools
import PromiseKit

final class DefaultDataProvider: DataProvider {

    // MARK: - Instance Properties

    private let dataCache = Cache<URL, Data>()

    // MARK: - Instance Methods

    func fetchData(from url: URL) -> Promise<Data> {
        return perform {
            if let data = self.dataCache.value(forKey: url) {
                return data
            }

            let data = try Data(contentsOf: url)

            self.dataCache.setValue(data, forKey: url)

            return data
        }
    }
}
