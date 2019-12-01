import Foundation
import FugenTools
import PromiseKit
import PathKit

final class DefaultImageResourcesProvider: ImageResourcesProvider {

    // MARK: - Instance Properties

    let dataProvider: DataProvider

    // MARK: - Initializers

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Instance Methods

    private func makeResourceImageContext(
        info: ImageNodeInfo,
        format: ImageFormat,
        folderPath: Path
    ) -> ResourceImageContext {
        let name = info.base.name.camelized

        let filePaths = info.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath.appending(
                fileName: name.appending(scale.fileNameSuffix),
                extension: format.fileExtension
            )
        }

        return ResourceImageContext(info: info, name: name, filePaths: filePaths)
    }

    private func makeResourceImageContexts(
        info: [ImageNodeInfo],
        format: ImageFormat,
        folderPath: Path
    ) -> [ResourceImageContext] {
        return info.map { makeResourceImageContext(info: $0, format: format, folderPath: folderPath) }
    }

    private func saveResourceImageFiles(context: ResourceImageContext) -> Promise<Void> {
        let promises = context.info.urls.compactMap { scale, url in
            context.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0.string) }
        }

        return when(fulfilled: promises)
    }

    private func saveResourceImageFiles(contexts: [ResourceImageContext]) -> Promise<Void> {
        let promises = contexts.map { context in
            saveResourceImageFiles(context: context)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageNodeInfo: ImageResourceInfo]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeResourceImageContexts(
                info: info,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { contexts in
            self.saveResourceImageFiles(contexts: contexts)
        }.mapValues { context in
            (context.info, ImageResourceInfo(name: context.name))
        }.map { items in
            Dictionary(items) { $1 }
        }
    }
}

private struct ResourceImageContext {

    // MARK: - Instance Properties

    let info: ImageNodeInfo
    let name: String
    let filePaths: [ImageScale: Path]
}
