import Foundation

struct FigmaFrameNodeInfo: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case children
        case isLocked = "locked"
        case background
        case exportSettings
        case rawBlendMode = "blendMode"
        case preserveRatio
        case constraints
        case transitionNodeID
        case transitionDuration
        case rawTransitionEasing
        case opacity
        case absoluteBoundingBox
        case clipsContent
        case layoutGrids
        case effects
        case isMask
        case isMaskOutline
    }

    // MARK: - Instance Properties

    let children: [FigmaNode]?
    let isLocked: Bool?
    let background: [FigmaPaint]?
    let exportSettings: [FigmaExportSetting]?
    let rawBlendMode: String?
    let preserveRatio: Bool?
    let constraints: FigmaLayoutConstraint?
    let transitionNodeID: String?
    let transitionDuration: Double?
    let rawTransitionEasing: String?
    let opacity: Double?
    let absoluteBoundingBox: FigmaRectangle?
    let clipsContent: Bool?
    let layoutGrids: [FigmaLayoutGrid]?
    let effects: [FigmaEffect]?
    let isMask: Bool?
    let isMaskOutline: Bool?

    var blendMode: FigmaBlendMode? {
        rawBlendMode.flatMap(FigmaBlendMode.init)
    }

    var transitionEasing: FigmaEasingType? {
        rawTransitionEasing.flatMap(FigmaEasingType.init)
    }
}
