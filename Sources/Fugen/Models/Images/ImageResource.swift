import Foundation

struct ImageResource: Encodable, Hashable {

    // MARK: - Instance Properties

    let fileName: String
    let fileExtension: String
    let filePaths: [ImageScale: String]
}
