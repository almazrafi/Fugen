import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultDataProvider: DataProvider {

    // MARK: - Instance Properties

    private let dataCache = Cache<URL, Data>()

    // MARK: - Instance Methods

    func fetchData(from url: URL) -> Promise<Data> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            if let data = self.dataCache.value(forKey: url) {
                return data
            }

            return try Data(contentsOf: url)
        }.get { data in
            self.dataCache.setValue(data, forKey: url)
        }
    }

    func saveData(from url: URL, to filePath: String) -> Promise<Void> {
        return firstly {
            self.fetchData(from: url)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { fileData in
            let filePath = Path(filePath)

            if filePath.exists {
                try filePath.delete()
            }

            try filePath.parent().mkpath()
            try filePath.write(fileData)
        }
    }
}
