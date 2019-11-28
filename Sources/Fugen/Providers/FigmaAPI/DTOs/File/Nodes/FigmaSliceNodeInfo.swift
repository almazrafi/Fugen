import Foundation

struct FigmaSliceNodeInfo: Decodable, Hashable {

    // MARK: - Instance Properties

    let exportSettings: [FigmaExportSetting]?
    let absoluteBoundingBox: FigmaRectangle?
}
