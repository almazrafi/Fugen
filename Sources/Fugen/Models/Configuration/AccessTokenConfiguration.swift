import Foundation

enum AccessTokenConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case environmentVariable = "env"
    }

    // MARK: - Enumeration Cases

    case environmentVariable(String)
    case value(String)

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            self = .environmentVariable(try container.decode(String.self, forKey: .environmentVariable))
        } else {
            self = .value(try String(from: decoder))
        }
    }
}
