import Foundation
import FugenTools

struct BaseConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case file
        case accessToken
    }

    // MARK: - Instance Properties

    let file: FileConfiguration?
    let accessToken: String?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        file = try container.decodeIfPresent(forKey: .file)

        switch try container.decodeIfPresent(AccessToken.self, forKey: .accessToken) {
        case let .environmentVariable(accessTokenVariable):
            accessToken = ProcessInfo.processInfo.environment[accessTokenVariable]

        case let .value(accessTokenValue):
            accessToken = accessTokenValue

        case nil:
            accessToken = nil
        }
    }
}

private enum AccessToken: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case environmentVariable = "env"
    }

    // MARK: - Enumeration Cases

    case environmentVariable(String)
    case value(String)

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self = .environmentVariable(try container.decode(String.self, forKey: .environmentVariable))
        } else {
            self = .value(try String(from: decoder))
        }
    }
}
