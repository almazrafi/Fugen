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

    private func makeResourceInfo(
        for info: ImageNodeInfo,
        format: ImageFormat,
        folderPath: Path
    ) -> ImageResourceInfo {
        let fileName = info.base.name.camelized
        let fileExtension = format.fileExtension

        let filePaths = info.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: fileName.appending(scale.fileNameSuffix), extension: fileExtension)
                .string
        }

        return ImageResourceInfo(fileName: fileName, fileExtension: fileExtension, filePaths: filePaths)
    }

    private func makeResourcesInfo(
        info: [ImageNodeInfo],
        format: ImageFormat,
        folderPath: Path
    ) -> [ImageNodeInfo: ImageResourceInfo] {
        var resourceInfo: [ImageNodeInfo: ImageResourceInfo] = [:]

        info.forEach { info in
            resourceInfo[info] = makeResourceInfo(for: info, format: format, folderPath: folderPath)
        }

        return resourceInfo
    }

    private func saveImageFiles(info: ImageNodeInfo, resourceInfo: ImageResourceInfo) -> Promise<Void> {
        let promises = info.urls.compactMap { scale, url in
            resourceInfo.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(resourcesInfo: [ImageNodeInfo: ImageResourceInfo]) -> Promise<Void> {
        let promises = resourcesInfo.map { info, resourceInfo in
            saveImageFiles(info: info, resourceInfo: resourceInfo)
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
            self.makeResourcesInfo(
                info: info,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { resourcesInfo in
            self.saveImageFiles(resourcesInfo: resourcesInfo)
        }
    }
}
