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

    private func extractImageURL(from rawURLs: [String: String?], info: ImageNodeBaseInfo) throws -> URL {
        guard let rawURL = rawURLs[info.id]?.flatMap({ $0 }) else {
            throw ImageRenderProviderError(code: .invalidImage, nodeID: info.id, nodeName: info.name)
        }

        guard let url = URL(string: rawURL) else {
            throw ImageRenderProviderError(code: .invalidImageURL, nodeID: info.id, nodeName: info.name)
        }

        return url
    }

    private func extractImageURLs(
        from rawURLs: [String: String?],
        info: [ImageNodeBaseInfo]
    ) throws -> [ImageNodeBaseInfo: URL] {
        var urls: [ImageNodeBaseInfo: URL] = [:]

        try info.forEach { info in
            urls[info] = try self.extractImageURL(from: rawURLs, info: info)
        }

        return urls
    }

    private func makeImageRenderedNode(
        info: ImageNodeBaseInfo,
        imageURLs: [ImageScale: [ImageNodeBaseInfo: URL]]
    ) -> ImageNodeInfo {
        let scales = imageURLs.keys

        let nodeImageURLs = scales.reduce(into: [:]) { result, scale in
            result[scale] = imageURLs[scale]?[info]
        }

        return ImageNodeInfo(base: info, urls: nodeImageURLs)
    }

    private func renderImages(
        of file: FileParameters,
        info: [ImageNodeBaseInfo],
        format: ImageFormat,
        scale: ImageScale
    ) -> Promise<[ImageNodeBaseInfo: URL]> {
        let route = FigmaAPIImagesRoute(
            accessToken: file.accessToken,
            fileKey: file.key,
            fileVersion: file.version,
            nodeIDs: info.map { $0.id },
            format: format.figmaFormat,
            scale: scale.figmaScale
        )

        return firstly {
            self.apiProvider.request(route: route)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { images in
            try self.extractImageURLs(from: images.urls, info: info)
        }
    }

    // MARK: -

    func renderImages(
        of file: FileParameters,
        info: [ImageNodeBaseInfo],
        format: ImageFormat,
        scales: [ImageScale]
    ) -> Promise<[ImageNodeInfo]> {
        guard !info.isEmpty else {
            return .value([])
        }

        let promises = scales.map { scale in
            renderImages(of: file, info: info, format: format, scale: scale).map { imageURLs in
                (scale: scale, imageURLs: imageURLs)
            }
        }

        return firstly {
            when(fulfilled: promises)
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            Dictionary(imageURLs) { $1 }
        }.map(on: DispatchQueue.global(qos: .userInitiated)) { imageURLs in
            info.map { self.makeImageRenderedNode(info: $0, imageURLs: imageURLs) }
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
