import Foundation

struct ImageNodeInfo: Hashable {

    // MARK: - Instance Properties

    let base: ImageNodeBaseInfo
    let urls: [ImageScale: URL]
}
