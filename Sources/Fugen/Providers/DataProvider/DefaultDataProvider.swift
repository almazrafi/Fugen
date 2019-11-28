import Foundation

class DefaultDataProvider: DataProvider {

    // MARK: - Instance Properties

    private let dataCache = NSCache<DataCacheKey, DataCacheValue>()

    // MARK: - Instance Methods

    func fetchData(from url: URL) throws -> Data {
        let dataCacheKey = DataCacheKey(url: url)

        if let dataCacheValue = dataCache.object(forKey: dataCacheKey) {
            return dataCacheValue.data
        }

        let data = try Data(contentsOf: url)
        let dataCacheValue = DataCacheValue(data: data)

        dataCache.setObject(dataCacheValue, forKey: dataCacheKey)

        return data
    }
}

private class DataCacheKey {

    let url: URL

    init(url: URL) {
        self.url = url
    }
}

private class DataCacheValue {

    let data: Data

    init(data: Data) {
        self.data = data
    }
}
