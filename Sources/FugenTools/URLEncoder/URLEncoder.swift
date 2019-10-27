import Foundation

public final class URLEncoder {

    // MARK: - Type Properties

    public static let `default` = URLEncoder()

    // MARK: - Instance Properties

    public var boolEncodingStrategy: URLBoolEncodingStrategy
    public var dateEncodingStrategy: URLDateEncodingStrategy
    public var arrayEncodingStrategy: URLArrayEncodingStrategy
    public var spaceEncodingStrategy: URLSpaceEncodingStrategy

    // MARK: - Initializers

    public init(
        boolEncodingStrategy: URLBoolEncodingStrategy = .numeric,
        dateEncodingStrategy: URLDateEncodingStrategy = .deferredToDate,
        arrayEncodingStrategy: URLArrayEncodingStrategy = .brackets,
        spaceEncodingStrategy: URLSpaceEncodingStrategy = .percentEscaped
    ) {
        self.boolEncodingStrategy = boolEncodingStrategy
        self.dateEncodingStrategy = dateEncodingStrategy
        self.arrayEncodingStrategy = arrayEncodingStrategy
        self.spaceEncodingStrategy = spaceEncodingStrategy
    }

    // MARK: - Instance Methods

    public func encodeToQuery<T: Encodable>(_ value: T) throws -> String {
        let urlEncodedFormContext = URLEncodedFormContext(component: .dictionary([:]))

        let urlEncodedFormEncoder = URLEncodedFormEncoder(
            context: urlEncodedFormContext,
            boolEncodingStrategy: boolEncodingStrategy,
            dateEncodingStrategy: dateEncodingStrategy
        )

        try value.encode(to: urlEncodedFormEncoder)

        guard case let .dictionary(urlEncodedForm) = urlEncodedFormContext.component else {
            let errorContext = EncodingError.Context(
                codingPath: [],
                debugDescription: "Root component cannot be encoded in URL"
            )

            throw EncodingError.invalidValue("\(value)", errorContext)
        }

        let serializer = URLEncodedFormSerializer(
            arrayEncodingStrategy: arrayEncodingStrategy,
            spaceEncodingStrategy: spaceEncodingStrategy
        )

        return serializer.serialize(urlEncodedForm)
    }

    public func encode<T: Encodable>(_ value: T) throws -> Data {
        let query = try encodeToQuery(value)

        return Data(query.utf8)
    }
}
