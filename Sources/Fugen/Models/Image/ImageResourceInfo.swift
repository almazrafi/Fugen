import Foundation

struct ImageResourceInfo: Hashable {

    // MARK: - Instance Properties

    let fileName: String
    let fileExtension: String
    let filePaths: [ImageScale: String]
}
