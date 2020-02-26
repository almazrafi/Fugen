import Foundation

public enum AssetIdiom: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case idiom
        case idiomSubtype = "subtype"
        case screenWidth = "screen-width"
    }

    private enum CodingType: String, Codable {
        case universal
        case iPhone = "iphone"
        case iPad = "ipad"
        case mac
        case watch
        case tv
        case car
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

        switch try container.decode(CodingType.self, forKey: .idiom) {
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
            try container.encode(CodingType.universal, forKey: .idiom)

        case .iPhone:
            try container.encode(CodingType.iPhone, forKey: .idiom)

        case let .iPad(subtype):
            try container.encode(CodingType.iPad, forKey: .idiom)
            try container.encodeIfPresent(subtype, forKey: .idiomSubtype)

        case .mac:
            try container.encode(CodingType.mac, forKey: .idiom)

        case let .watch(screenWidth):
            try container.encode(CodingType.watch, forKey: .idiom)
            try container.encodeIfPresent(screenWidth, forKey: .screenWidth)

        case .tv:
            try container.encode(CodingType.tv, forKey: .idiom)

        case .car:
            try container.encode(CodingType.car, forKey: .idiom)
        }
    }
}
