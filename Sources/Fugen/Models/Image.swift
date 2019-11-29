import Foundation

struct Image: Hashable {

    // MARK: - Instance Properties

    let name: String
    let description: String?
    let format: ImageFormat
    let urls: [ImageScale: URL]
}
