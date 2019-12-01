import Foundation

struct FigmaEffect: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case rawType = "type"
        case isVisible = "visible"
        case radius
        case color
        case rawBlendMode = "blendMode"
        case offset
    }

    // MARK: - Instance Properties

    let rawType: String
    let isVisible: Bool?
    let radius: Double?
    let color: FigmaColor?
    let rawBlendMode: String?
    let offset: FigmaVector?

    var type: FigmaEffectType? {
        FigmaEffectType(rawValue: rawType)
    }

    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }
}
