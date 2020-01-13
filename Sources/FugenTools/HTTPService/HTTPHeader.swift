import Foundation

public struct HTTPHeader: Equatable, CustomStringConvertible {

    // MARK: - Type Methods

    private static func qualityEncoded<T: Collection> (_ collection: T) -> String where T.Element == String {
        return collection
            .enumerated()
            .map { "\($1);q=\(1.0 - (Double($0) * 0.1))" }
            .joined(separator: ", ")
    }

    // MARK: -

    public static func acceptCharset(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Accept-Charset", value: value)
    }

    public static func acceptLanguage(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Accept-Language", value: value)
    }

    public static func acceptEncoding(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Accept-Encoding", value: value)
    }

    public static func authorization(username: String, password: String) -> HTTPHeader {
        let credential = Data("\(username):\(password)".utf8).base64EncodedString()

        return authorization("Basic \(credential)")
    }

    public static func authorization(bearerToken: String) -> HTTPHeader {
        return authorization("Bearer \(bearerToken)")
    }

    public static func authorization(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Authorization", value: value)
    }

    public static func contentDisposition(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Content-Disposition", value: value)
    }

    public static func contentType(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Content-Type", value: value)
    }

    public static func userAgent(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "User-Agent", value: value)
    }

    public static func cookie(_ value: String) -> HTTPHeader {
        return HTTPHeader(name: "Cookie", value: value)
    }

    // MARK: -

    public static func defaultAcceptLanguage() -> HTTPHeader {
        return acceptLanguage(qualityEncoded(Locale.preferredLanguages.prefix(6)))
    }

    public static func defaultAcceptEncoding() -> HTTPHeader {
        let encodings: [String]

        if #available(iOS 11.0, macOS 10.13, tvOS 11.0, watchOS 4.0, *) {
            encodings = ["br", "gzip", "deflate"]
        } else {
            encodings = ["gzip", "deflate"]
        }

        return acceptEncoding(qualityEncoded(encodings))
    }

    public static func defaultUserAgent(bundle: Bundle = Bundle.main) -> HTTPHeader {
        let systemName: String

        #if os(iOS)
            systemName = "iOS"
        #elseif os(watchOS)
            systemName = "watchOS"
        #elseif os(tvOS)
            systemName = "tvOS"
        #elseif os(macOS)
            systemName = "macOS"
        #elseif os(Linux)
            systemName = "Linux"
        #else
            systemName = "Unknown"
        #endif

        let system = "\(systemName) \(ProcessInfo.processInfo.operatingSystemVersion.fullVersion)"

        let appBundleIdentifier = bundle.bundleIdentifier ?? "Unknown"
        let appExecutableName = bundle.executableName ?? "Unknown"
        let appVersion = bundle.version ?? "Unknown"
        let appBuild = bundle.build ?? "Unknown"

        return userAgent("\(appExecutableName)/\(appVersion) (\(appBundleIdentifier); build:\(appBuild); \(system))")
    }

    // MARK: - Instance Properties

    public let name: String
    public let value: String

    // MARK: - CustomStringConvertible

    public var description: String {
        "\(name): \(value)"
    }

    // MARK: - Initializers

    public init(name: String, value: String) {
        self.name = name
        self.value = value
    }
}

extension Collection where Element == HTTPHeader {

    // MARK: - Instance Properties

    public var rawHTTPHeaders: [String: String] {
        Dictionary(map { ($0.name, $0.value) }) { $1 }
    }
}
