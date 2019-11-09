import Foundation

struct FileConfiguration: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case key
        case version
        case includedNodes
        case excludedNodes
    }

    // MARK: - Instance Properties

    let key: String
    let version: String?
    let includedNodes: [String]?
    let excludedNodes: [String]?

    // MARK: - Initializers

    init(
        key: String,
        version: String?,
        includedNodes: [String],
        excludedNodes: [String]
    ) {
        self.key = key
        self.version = version
        self.includedNodes = includedNodes
        self.excludedNodes = excludedNodes
    }

    init(from decoder: Decoder) throws {
        if let container = try? decoder.container(keyedBy: CodingKeys.self) {
            key = try container.decode(forKey: .key)
            version = try container.decodeIfPresent(forKey: .version)
            includedNodes = try container.decodeIfPresent(forKey: .includedNodes)
            excludedNodes = try container.decodeIfPresent(forKey: .excludedNodes)
        } else {
            key = try decoder.singleValueContainer().decode(String.self)
            version = nil
            includedNodes = nil
            excludedNodes = nil
        }
    }
}
