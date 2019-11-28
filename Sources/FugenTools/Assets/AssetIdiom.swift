import Foundation

public enum AssetIdiom: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case idiom
        case idiomSubtype = "subtype"
        case screenWidth = "screen-width"
    }

    // MARK: - Enumeration Cases

    case universal
    case iPhone
    case iPad(subtype: AssetIdiomIPadSubtype?)
    case mac
    case watch(screenWidth: String?)
    case tv
    case car

    // MARK: - Initializers

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        switch try container.decode(AssetIdiomRawType.self, forKey: .idiom) {
        case .universal:
            self = .universal

        case .iPhone:
            self = .iPhone

        case .iPad:
            self = .iPad(subtype: try container.decodeIfPresent(forKey: .idiomSubtype))

        case .mac:
            self = .mac

        case .watch:
            self = .watch(screenWidth: try container.decodeIfPresent(forKey: .screenWidth))

        case .tv:
            self = .tv

        case .car:
            self = .car
        }
    }

    // MARK: - Instance Methods

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .universal:
            try container.encode(AssetIdiomRawType.universal, forKey: .idiom)

        case .iPhone:
            try container.encode(AssetIdiomRawType.iPhone, forKey: .idiom)

        case let .iPad(subtype):
            try container.encode(AssetIdiomRawType.iPad, forKey: .idiom)
            try container.encodeIfPresent(subtype, forKey: .idiomSubtype)

        case .mac:
            try container.encode(AssetIdiomRawType.mac, forKey: .idiom)

        case let .watch(screenWidth):
            try container.encode(AssetIdiomRawType.watch, forKey: .idiom)
            try container.encodeIfPresent(screenWidth, forKey: .screenWidth)

        case .tv:
            try container.encode(AssetIdiomRawType.tv, forKey: .idiom)

        case .car:
            try container.encode(AssetIdiomRawType.car, forKey: .idiom)
        }
    }
}

private enum AssetIdiomRawType: String, Codable {

    // MARK: - Enumeration Cases

    case universal
    case iPhone = "iphone"
    case iPad = "ipad"
    case mac
    case watch
    case tv
    case car
}
