import Foundation

struct FigmaExportSetting: Decodable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case suffix
        case rawFormat = "format"
        case constraint
    }

    // MARK: - Instance Properties

    let suffix: String?
    let rawFormat: String
    let constraint: FigmaConstraint?

    var format: FigmaImageFormat? {
        FigmaImageFormat(rawValue: rawFormat)
    }
}
