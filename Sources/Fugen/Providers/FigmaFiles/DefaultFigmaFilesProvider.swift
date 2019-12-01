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

    func fetchFile(_ file: FileParameters) -> Promise<FigmaFile> {
        let fileUniqueID = "\(file.key): \(file.version ?? "nil")"

        if let filePromise = filePromises[fileUniqueID] {
            return filePromise
        }

        let route = FigmaAPIFileRoute(
            accessToken: file.accessToken,
            fileKey: file.key,
            version: file.version
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
