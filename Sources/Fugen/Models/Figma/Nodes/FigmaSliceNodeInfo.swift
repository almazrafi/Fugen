import Foundation

struct FigmaSliceNodeInfo: Decodable {

    // MARK: - Instance Properties

    let exportSettings: [FigmaExportSetting]?
    let absoluteBoundingBox: FigmaRectangle
}
