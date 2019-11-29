import Foundation
import PromiseKit

class DefaultImagesProvider: ImagesProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider
    let filesProvider: FigmaFilesProvider
    let nodesProvider: FigmaNodesProvider

    // MARK: - Initializers

    init(
        apiProvider: FigmaAPIProvider,
        filesProvider: FigmaFilesProvider,
        nodesProvider: FigmaNodesProvider
    ) {
        self.apiProvider = apiProvider
        self.filesProvider = filesProvider
        self.nodesProvider = nodesProvider
    }

    // MARK: - Instance Methods

    private func extractImageMetadata(
        from node: FigmaNode,
        components: [String: FigmaComponent]
    ) throws -> ImageMetadata? {
        guard case .component = node.type else {
            return nil
        }

        guard let nodeComponent = components[node.id] else {
            throw ImagesProviderError(code: .componentNotFound, nodeID: node.id, nodeName: node.name)
        }

        guard let nodeComponentName = nodeComponent.name, !nodeComponentName.isEmpty else {
            throw ImagesProviderError(code: .invalidComponentName, nodeID: node.id, nodeName: node.name)
        }

        return ImageMetadata(
            id: node.id,
            name: nodeComponentName,
            description: nodeComponent.description
        )
    }

    private func extractImageMetadata(
        from file: FigmaFile,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?
    ) throws -> [ImageMetadata] {
        let components = file.components ?? [:]

        return try nodesProvider
            .fetchNodes(from: file, including: includedNodeIDs, excluding: excludedNodeIDs)
            .lazy
            .compactMap { try extractImageMetadata(from: $0, components: components) }
            .reduce(into: []) { result, imageNodeID in
                if !result.contains(imageNodeID) {
                    result.append(imageNodeID)
                }
            }
    }

    private func extractImageURL(
        from imageRawURLs: [String: String?],
        metadata: ImageMetadata
    ) throws -> URL {
        guard let imageURLString = imageRawURLs[metadata.id]?.flatMap({ $0 }) else {
            throw ImagesProviderError(code: .invalidImage, nodeID: metadata.id, nodeName: metadata.name)
        }

        guard let imageURL = URL(string: imageURLString) else {
            throw ImagesProviderError(code: .invalidImageURL, nodeID: metadata.id, nodeName: metadata.name)
        }

        return imageURL
    }

    private func extractImageURLs(
        from imageRawURLs: [String: String?],
        metadata: [ImageMetadata]
    ) throws -> [ImageMetadata: URL] {
        var imageURLs: [ImageMetadata: URL] = [:]

        try metadata.forEach { metadata in
            imageURLs[metadata] = try self.extractImageURL(from: imageRawURLs, metadata: metadata)
        }

        return imageURLs
    }

    private func extractImages(
        from imageURLs: [ImageScale: [ImageMetadata: URL]],
        metadata: [ImageMetadata],
        format: ImageFormat
    ) -> [Image] {
        let scales = imageURLs.keys

        return metadata.map { metadata in
            let urls = scales.reduce(into: [:]) { result, scale in
                result[scale] = imageURLs[scale]?[metadata]
            }

            return Image(
                name: metadata.name,
                description: metadata.description,
                format: format,
                urls: urls
            )
        }
    }

    private func renderImages(
        metadata: [ImageMetadata],
        fileKey: String,
        fileVersion: String?,
        format: ImageFormat,
        scale: ImageScale,
        accessToken: String
    ) -> Promise<[ImageMetadata: URL]> {
        let route = FigmaAPIImagesRoute(
            accessToken: accessToken,
            fileKey: fileKey,
            fileVersion: fileVersion,
            nodeIDs: metadata.map { $0.id },
            format: format.figmaFormat,
            scale: scale.figmaScale
        )

        return firstly {
            self.apiProvider.request(route: route)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { images in
            try self.extractImageURLs(from: images.urls, metadata: metadata)
        }
    }

    private func renderImages(
        metadata: [ImageMetadata],
        fileKey: String,
        fileVersion: String?,
        format: ImageFormat,
        scales: [ImageScale],
        accessToken: String
    ) -> Promise<[Image]> {
        let promises = scales.map { scale in
            self.renderImages(
                metadata: metadata,
                fileKey: fileKey,
                fileVersion: fileVersion,
                format: format,
                scale: scale,
                accessToken: accessToken
            ).map { (scale: scale, urls: $0) }
        }

        return firstly {
            when(fulfilled: promises)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            self.extractImages(
                from: Dictionary(imageURLs) { $1 },
                metadata: metadata,
                format: format
            )
        }
    }

    // MARK: -

    func fetchImages(
        fileKey: String,
        fileVersion: String?,
        includingNodes includedNodeIDs: [String]?,
        excludingNodes excludedNodeIDs: [String]?,
        format: ImageFormat,
        scales: [ImageScale],
        accessToken: String
    ) -> Promise<[Image]> {
        return firstly {
            self.filesProvider.fetchFile(key: fileKey, version: fileVersion, accessToken: accessToken)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { file in
            try self.extractImageMetadata(
                from: file,
                includingNodes: includedNodeIDs,
                excludingNodes: excludedNodeIDs
            )
        }.then { imageMetadata in
            self.renderImages(
                metadata: imageMetadata,
                fileKey: fileKey,
                fileVersion: fileVersion,
                format: format,
                scales: scales,
                accessToken: accessToken
            )
        }
    }
}

private struct ImageMetadata: Hashable {

    // MARK: - Instance Properties

    let id: String
    let name: String
    let description: String?
}

private extension ImageFormat {

    // MARK: - Instance Properties

    var figmaFormat: FigmaImageFormat {
        switch self {
        case .pdf:
            return .pdf

        case .png:
            return .png

        case .jpg:
            return .jpg

        case .svg:
            return .svg
        }
    }
}

private extension ImageScale {

    // MARK: - Instance Properties

    var figmaScale: Double {
        switch self {
        case .single, .scale1x:
            return 1.0

        case .scale2x:
            return 2.0

        case .scale3x:
            return 3.0

        case .scale4x:
            return 4.0
        }
    }
}
