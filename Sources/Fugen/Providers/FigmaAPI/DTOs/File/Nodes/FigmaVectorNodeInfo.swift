import Foundation

struct FigmaVectorNodeInfo: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case isLocked = "locked"
        case exportSettings
        case rawBlendMode = "blendMode"
        case preserveRatio
        case constraints
        case transitionNodeID
        case transitionDuration
        case rawTransitionEasing
        case opacity
        case absoluteBoundingBox
        case effects
        case isMask
        case fills
        case strokes
        case strokeWeight
        case rawStrokeCap = "strokeCap"
        case rawStrokeJoin = "strokeJoin"
        case strokeDashes
        case strokeMiterAngle
        case rawStrokeAlignment = "strokeAlign"
        case styles
    }

    // MARK: - Instance Properties

    let isLocked: Bool?
    let exportSettings: [FigmaExportSetting]?
    let rawBlendMode: String?
    let preserveRatio: Bool?
    let constraints: FigmaLayoutConstraint?
    let transitionNodeID: String?
    let transitionDuration: Double?
    let rawTransitionEasing: String?
    let opacity: Double?
    let absoluteBoundingBox: FigmaRectangle?
    let effects: [FigmaEffect]?
    let isMask: Bool?
    let fills: [FigmaPaint]?
    let strokes: [FigmaPaint]?
    let strokeWeight: Double?
    let rawStrokeCap: String?
    let rawStrokeJoin: String?
    let strokeDashes: [Double]?
    let strokeMiterAngle: Double?
    let rawStrokeAlignment: String?
    let styles: [String: String]?

    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }

    var transitionEasing: FigmaEasingType? {
        rawTransitionEasing.flatMap(FigmaEasingType.init)
    }

    var strokeCap: FigmaStrokeCap? {
        guard let rawStrokeCap = rawStrokeCap else {
            return FigmaStrokeCap.none
        }

        return FigmaStrokeCap(rawValue: rawStrokeCap)
    }

    var strokeJoin: FigmaStrokeJoin? {
        guard let rawStrokeJoin = rawStrokeJoin else {
            return FigmaStrokeJoin.miter
        }

        return FigmaStrokeJoin(rawValue: rawStrokeJoin)
    }

    var strokeAlignment: FigmaStrokeAlignment? {
        rawStrokeAlignment.flatMap(FigmaStrokeAlignment.init)
    }

    // MARK: - Instance Methods

    func styleID(of styleType: FigmaStyleType) -> String? {
        return styles?[styleType.rawValue.lowercased()]
    }
}
