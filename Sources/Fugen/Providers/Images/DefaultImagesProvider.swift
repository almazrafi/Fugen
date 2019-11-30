import Foundation
import FugenTools
import PromiseKit

final class DefaultImagesProvider: ImagesProvider {

    // MARK: - Instance Properties

    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider
    let imageRenderProvider: ImageRenderProvider
    let imageAssetsProvider: ImageAssetsProvider
    let imageResourcesProvider: ImageResourcesProvider

    // MARK: - Initializers

    init(
        filesProvider: FigmaFilesProvider,
        nodesProvider: FigmaNodesProvider,
        imageRenderProvider: ImageRenderProvider,
        imageAssetsProvider: ImageAssetsProvider,
        imageResourcesProvider: ImageResourcesProvider
    ) {
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
        self.imageRenderProvider = imageRenderProvider
        self.imageAssetsProvider = imageAssetsProvider
        self.imageResourcesProvider = imageResourcesProvider
    }

    // MARK: - Instance Methods

    private func extractImageInfo(
        from node: FigmaNode,
        components: [String: FigmaComponent]
    ) throws -> ImageNodeBaseInfo? {
        guard case .component = node.type else {
            return nil
        }

        guard let nodeComponent = components[node.id] else {
            throw ImagesProviderError(code: .componentNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeComponentName = nodeComponent.name, !nodeComponentName.isEmpty else {
            throw ImagesProviderError(code: .invalidComponentName, nodeID: node.id, nodeName: node.name)
        }

        return ImageNodeBaseInfo(id: node.id, name: nodeComponentName, description: nodeComponent.description)
    }

    private func extractImagesInfo(from nodes: [FigmaNode], of file: FigmaFile) throws -> [ImageNodeBaseInfo] {
        let components = file.components ?? [:]

        return try nodes
            .lazy
            .compactMap { try extractImageInfo(from: $0, components: components) }
            .reduce(into: []) { result, imageNodeID in
                if !result.contains(imageNodeID) {
                    result.append(imageNodeID)
                }
            }
    }

    private func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        assets: String?
    ) -> Promise<[ImageNodeInfo: ImageAssetInfo]> {
        return assets.map { folderPath in
            imageAssetsProvider.saveImages(info: info, format: format, in: folderPath)
        } ?? .value([:])
    }

    private func saveImages(
        info: [ImageNodeInfo],
        format: ImageFormat,
        resources: String?
    ) -> Promise<[ImageNodeInfo: ImageResourceInfo]> {
        return resources.map { folderPath in
            imageResourcesProvider.saveImages(info: info, format: format, in: folderPath)
        } ?? .value([:])
    }

    private func makeImages(
        info: [ImageNodeInfo],
        assetsInfo: [ImageNodeInfo: ImageAssetInfo],
        resourcesInfo: [ImageNodeInfo: ImageResourceInfo]
    ) -> [Image] {
        return info.map { info in
            Image(info: info, assetInfo: assetsInfo[info], resourceInfo: resourcesInfo[info])
        }
    }

    // MARK: -

    func fetchImages(
        from file: FileParameters,
        nodes: NodesParameters,
        parameters: ImagesParameters
    ) -> Promise<[Image]> {
        return firstly {
            self.filesProvider.fetchFile(file)
        }.then { figmaFile in
            self.nodesProvider.fetchNodes(nodes, from: figmaFile).map { figmaNodes in
                try self.extractImagesInfo(from: figmaNodes, of: figmaFile)
            }
        }.then { info in
            self.imageRenderProvider.renderImages(
                of: file,
                info: info,
                format: parameters.format,
                scales: parameters.scales
            )
        }.then { info in
            firstly {
                when(
                    fulfilled: self.saveImages(info: info, format: parameters.format, assets: parameters.assets),
                    self.saveImages(info: info, format: parameters.format, resources: parameters.resources)
                )
            }.map { assetsInfo, resourcesInfo in
                self.makeImages(info: info, assetsInfo: assetsInfo, resourcesInfo: resourcesInfo)
            }
        }
    }
}
