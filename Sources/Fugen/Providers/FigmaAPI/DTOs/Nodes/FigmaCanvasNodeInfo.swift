import Foundation

struct FigmaCanvasNodeInfo: Decodable, Hashable {

    // MARK: - Instance Properties

    let children: [FigmaNode]?
    let backgroundColor: FigmaColor?
    let prototypeStartNodeID: String?
    let exportSettings: [FigmaExportSetting]?
}
