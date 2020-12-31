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

    private func extractImageNode(
        from node: FigmaNode,
        components: [String: FigmaComponent],
        onlyExportables: Bool
    ) throws -> ImageNode? {
        guard case .component(let info) = node.type else {
            return nil
        }

        guard !onlyExportables || !info.exportSettings.isEmptyOrNil else {
            return nil
        }

        guard let nodeComponent = components[node.id] else {
            throw ImagesProviderError(code: .componentNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeComponentName = nodeComponent.name, !nodeComponentName.isEmpty else {
            throw ImagesProviderError(code: .invalidComponentName, nodeID: node.id, nodeName: node.name)
        }

        return ImageNode(
            id: node.id,
            name: nodeComponentName,
            description: nodeComponent.description
        )
    }

    private func extractImageNodes(
        from nodes: [FigmaNode],
        of file: FigmaFile,
        onlyExportables: Bool
    ) throws -> [ImageNode] {
        let components = file.components ?? [:]

        return try nodes
            .lazy
            .filter { $0.isVisible ?? true }
            .compactMap { node in
                try extractImageNode(
                    from: node,
                    components: components,
                    onlyExportables: onlyExportables
                )
            }
            .reduce(into: []) { result, node in
                if !result.contains(node) {
                    result.append(node)
                }
            }
    }

    private func saveAssetImagesIfNeeded(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        preserveVectorData: Bool,
        in assets: String?
    ) -> Promise<[ImageRenderedNode: ImageAsset]> {
        return assets.map { folderPath in
            imageAssetsProvider.saveImages(
                nodes: nodes,
                format: format,
                preserveVectorData: preserveVectorData,
                in: folderPath
            )
        } ?? .value([:])
    }

    private func saveResourceImagesIfNeeded(
        nodes: [ImageRenderedNode],
        format: ImageFormat,
        in resources: String?
    ) -> Promise<[ImageRenderedNode: ImageResource]> {
        return resources.map { folderPath in
            imageResourcesProvider.saveImages(nodes: nodes, format: format, in: folderPath)
        } ?? .value([:])
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
                try self.extractImageNodes(
                    from: figmaNodes,
                    of: figmaFile,
                    onlyExportables: parameters.onlyExportables
                )
            }
        }.then { nodes in
           self.imageRenderProvider.renderImages(
                of: file,
                nodes: nodes,
                format: parameters.format,
                scales: parameters.scales,
                useAbsoluteBounds: parameters.useAbsoluteBounds
            )
        }.then { nodes in
            firstly {
                when(
                    fulfilled: self.saveAssetImagesIfNeeded(
                        nodes: nodes,
                        format: parameters.format,
                        preserveVectorData: parameters.preserveVectorData,
                        in: parameters.assets
                    ),
                    self.saveResourceImagesIfNeeded(
                        nodes: nodes,
                        format: parameters.format,
                        in: parameters.resources
                    )
                )
            }.map { assets, resources in
                nodes.map { node in
                    Image(
                        node: node,
                        format: parameters.format,
                        asset: assets[node],
                        resource: resources[node]
                    )
                }
            }
        }
    }
}
