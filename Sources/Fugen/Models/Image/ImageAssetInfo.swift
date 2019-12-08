import Foundation

struct ImageAssetInfo: Hashable {

    // MARK: - Instance Properties

    let name: String
    let filePaths: [ImageScale: String]
}
