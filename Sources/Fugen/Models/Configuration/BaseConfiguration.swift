import Foundation

struct BaseConfiguration: Decodable {

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: String?
}
