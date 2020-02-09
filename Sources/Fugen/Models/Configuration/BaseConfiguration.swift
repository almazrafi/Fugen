import Foundation
import FugenTools

struct BaseConfiguration: Decodable {

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: AccessTokenConfiguration?
}
