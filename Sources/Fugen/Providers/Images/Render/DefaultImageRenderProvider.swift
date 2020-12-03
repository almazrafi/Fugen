import Foundation
import PromiseKit

final class DefaultImageRenderProvider: ImageRenderProvider {

    // MARK: - Instance Properties

    let apiProvider: FigmaAPIProvider

    // MARK: - Initializers

    init(apiProvider: FigmaAPIProvider) {
        self.apiProvider = apiProvider
    }

    // MARK: - Instance Methods

    private func extractImageURL(from rawURLs: [String: String?], node: ImageNode) throws -> URL {
        guard let rawURL = rawURLs[node.id]?.flatMap({ $0 }) else {
            throw ImageRenderProviderError(code: .invalidImage, nodeID: node.id, nodeName: node.name)
        }

        guard let url = URL(string: rawURL) else {
            throw ImageRenderProviderError(code: .invalidImageURL, nodeID: node.id, nodeName: node.name)
        }

        return url
    }

    private func extractImageURLs(from rawURLs: [String: String?], nodes: [ImageNode]) throws -> [ImageNode: URL] {
        var urls: [ImageNode: URL] = [:]

        try nodes.forEach { node in
            urls[node] = try self.extractImageURL(from: rawURLs, node: node)
        }

        return urls
    }

    private func makeImageRenderedNode(
        for node: ImageNode,
        imageURLs: [ImageScale: [ImageNode: URL]]
    ) -> ImageRenderedNode {
        let scales = imageURLs.keys

        let nodeImageURLs = scales.reduce(into: [:]) { result, scale in
            result[scale] = imageURLs[scale]?[node]
        }

        return ImageRenderedNode(base: node, urls: nodeImageURLs)
    }

    private func renderImages(
        of file: FileParameters,
        nodes: [ImageNode],
        format: ImageFormat,
        scale: ImageScale,
        useAbsoluteBounds: Bool
    ) -> Promise<[ImageNode: URL]> {
        let route = FigmaAPIImagesRoute(
            accessToken: file.accessToken,
            fileKey: file.key,
            fileVersion: file.version,
            nodeIDs: nodes.map { $0.id },
            format: format.figmaFormat,
            scale: scale.figmaScale,
            useAbsoluteBounds: useAbsoluteBounds
        )

        return firstly {
            self.apiProvider.request(route: route)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { images in
            try self.extractImageURLs(from: images.urls, nodes: nodes)
        }
    }

    // MARK: -

    func renderImages(
        of file: FileParameters,
        nodes: [ImageNode],
        format: ImageFormat,
        scales: [ImageScale],
        useAbsoluteBounds: Bool
    ) -> Promise<[ImageRenderedNode]> {
        guard !nodes.isEmpty else {
            return .value([])
        }

        let promises = scales.map { scale in
            renderImages(of: file, nodes: nodes, format: format, scale: scale, useAbsoluteBounds: useAbsoluteBounds)
                .map { imageURLs in
                    (scale: scale, imageURLs: imageURLs)
                }
        }

        return firstly {
            when(fulfilled: promises)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            Dictionary(imageURLs) { $1 }
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            nodes.map { self.makeImageRenderedNode(for: $0, imageURLs: imageURLs) }
        }
    }
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
        case .none, .scale1x:
            return 1.0

        case .scale2x:
            return 2.0

        case .scale3x:
            return 3.0
        }
    }
}
