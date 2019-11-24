import Foundation
import PromiseKit

final class DefaultFigmaFilesProvider: FigmaFilesProvider {

    // MARK: - Instance Properties

    private var filePromises: [String: Promise<FigmaFile>] = [:]

    // MARK: -

    let apiProvider: FigmaAPIProvider

    // MARK: - Initializers

    init(apiProvider: FigmaAPIProvider) {
        self.apiProvider = apiProvider
    }

    // MARK: - Instance Methods

    func fetchFile(key: String, version: String?, accessToken: String) -> Promise<FigmaFile> {
        let fileUniqueID = "\(key): \(version ?? "nil")"

        if let filePromise = filePromises[fileUniqueID] {
            return filePromise
        }

        let route = FigmaAPIFileRoute(
            accessToken: accessToken,
            fileKey: key,
            version: version
        )

        let promise = firstly {
            apiProvider.request(route: route)
        }.tap { result in
            if !result.isFulfilled {
                self.filePromises.removeValue(forKey: fileUniqueID)
            }
        }

        filePromises[fileUniqueID] = promise

        return promise
    }
}
