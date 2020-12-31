import Foundation

struct ImageAsset: Encodable, Hashable {

    // MARK: - Instance Properties

    let name: String
    let filePaths: [ImageScale: String]
    let preserveVectorData: Bool
}
