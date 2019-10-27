import Foundation

struct FigmaCanvasNodeInfo: Decodable {

    // MARK: - Instance Properties

    let children: [FigmaNode]
    let backgroundColor: FigmaColor
    let prototypeStartNodeID: String?
    let exportSettings: [FigmaExportSetting]?
}
