import Foundation

final class DefaultColorStylesCoder: ColorStylesCoder {

    // MARK: - Instance Properties

    let colorCoder: ColorCoder

    // MARK: - Initializers

    init(colorCoder: ColorCoder) {
        self.colorCoder = colorCoder
    }

    // MARK: - Instance Methods

    private func encodeColorStyleAssetInfo(_ assetInfo: ColorStyleAssetInfo) -> [String: Any] {
        return ["name": assetInfo.name]
    }

    // MARK: -

    func encodeColorStyle(_ colorStyle: ColorStyle) -> [String: Any] {
        let info = colorStyle.info

        var encodedColorStyle: [String: Any] = [
            "name": info.name,
            "color": colorCoder.encodeColor(info.color)
        ]

        if let description = info.description {
            encodedColorStyle["description"] = description
        }

        if let assetInfo = colorStyle.assetInfo {
            encodedColorStyle["asset"] = encodeColorStyleAssetInfo(assetInfo)
        }

        return encodedColorStyle
    }

    func encodeColorStyles(_ colorStyles: [ColorStyle]) -> [String: Any] {
        return ["colorStyles": colorStyles.map(encodeColorStyle)]
    }
}
