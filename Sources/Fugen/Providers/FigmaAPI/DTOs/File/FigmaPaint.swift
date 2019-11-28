import Foundation

struct FigmaPaint: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case isVisible = "visible"
        case opacity
        case color
        case rawBlendMode = "blendMode"
        case gradientHandlePositions
        case gradientStops
        case rawScaleMode = "scaleMode"
        case imageTransform
        case imageRef
        case gifRef
    }

    // MARK: - Instance Properties

    let rawType: String
    let isVisible: Bool?
    let opacity: Double?
    let color: FigmaColor?
    let rawBlendMode: String?
    let gradientHandlePositions: [FigmaVector]?
    let gradientStops: [FigmaColorStop]?
    let rawScaleMode: String?
    let imageTransform: [[Double]]?
    let imageRef: String?
    let gifRef: String?

    var type: FigmaPaintType? {
        FigmaPaintType(rawValue: rawType)
    }

    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }

    var scaleMode: FigmaScaleMode? {
        rawScaleMode.flatMap(FigmaScaleMode.init)
    }
}
