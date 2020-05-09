import Foundation

struct ImagesParameters {

    // MARK: - Instance Properties

    let format: ImageFormat
    let scales: [ImageScale]
    let assets: String?
    let resources: String?
    let onlyExportables: Bool
}
