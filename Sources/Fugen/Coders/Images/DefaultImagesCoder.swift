import Foundation

final class DefaultImagesCoder: ImagesCoder {

    // MARK: - Instance Methods

    private func encodeImageAssetInfo(_ assetInfo: ImageAssetInfo) -> [String: Any] {
        return ["name": assetInfo.name]
    }

    private func encodeImageResourceInfo(_ resourceInfo: ImageResourceInfo) -> [String: Any] {
        return ["name": resourceInfo.name]
    }

    // MARK: -

    func encodeImage(_ image: Image) -> [String: Any] {
        var encodedImage: [String: Any] = ["name": image.info.base.name]

        if let description = image.info.base.description {
            encodedImage["description"] = description
        }

        if let assetInfo = image.assetInfo {
            encodedImage["asset"] = encodeImageAssetInfo(assetInfo)
        }

        if let resourceInfo = image.resourceInfo {
            encodedImage["resource"] = encodeImageResourceInfo(resourceInfo)
        }

        return encodedImage
    }

    func encodeImages(_ images: [Image]) -> [String: Any] {
        return ["images": images.map(encodeImage)]
    }
}
