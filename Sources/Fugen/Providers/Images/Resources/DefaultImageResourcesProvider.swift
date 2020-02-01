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

    private func makeResource(for node: ImageRenderedNode, format: ImageFormat, folderPath: Path) -> ImageResource {
        let fileName = node.base.name.camelized
        let fileExtension = format.fileExtension

        let filePaths = node.urls.keys.reduce(into: [:]) { result, scale in
            result[scale] = folderPath
                .appending(fileName: fileName.appending(scale.fileNameSuffix), extension: fileExtension)
                .string
        }

        return ImageResource(fileName: fileName, fileExtension: fileExtension, filePaths: filePaths)
    }

    private func makeResources(
        for nodes: [ImageRenderedNode],
        format: ImageFormat,
        folderPath: Path
    ) -> [ImageRenderedNode: ImageResource] {
        var resources: [ImageRenderedNode: ImageResource] = [:]

        nodes.forEach { node in
            resources[node] = makeResource(for: node, format: format, folderPath: folderPath)
        }

        return resources
    }

    private func saveImageFiles(node: ImageRenderedNode, resource: ImageResource) -> Promise<Void> {
        let promises = node.urls.compactMap { scale, url in
            resource.filePaths[scale].map { self.dataProvider.saveData(from: url, to: $0) }
        }

        return when(fulfilled: promises)
    }

    private func saveImageFiles(resources: [ImageRenderedNode: ImageResource]) -> Promise<Void> {
        let promises = resources.map { node, resource in
            saveImageFiles(node: node, resource: resource)
        }

        return when(fulfilled: promises)
    }

    // MARK: -

    func saveImages(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        in folderPath: String
    ) -> Promise<[ImageRenderedNode: ImageResource]> {
        return perform(on: DispatchQueue.global(qos: .userInitiated)) {
            self.makeResources(
                for: nodes,
                format: format,
                folderPath: Path(folderPath)
            )
        }.nest { resources in
            self.saveImageFiles(resources: resources)
        }
    }
}
