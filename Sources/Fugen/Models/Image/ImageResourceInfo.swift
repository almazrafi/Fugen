import Foundation

struct ImageResourceInfo: Hashable {

    // MARK: - Instance Properties

    let name: String
    let filePaths: [ImageScale: String]
}
