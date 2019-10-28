import Foundation

extension Bundle {

    // MARK: - Instance Properties

    public var bundleName: String? {
        string(forInfoDictionaryKey: "CFBundleName")
    }

    public var developmentRegion: String? {
        string(forInfoDictionaryKey: "CFBundleDevelopmentRegion")
    }

    public var displayName: String? {
        string(forInfoDictionaryKey: "CFBundleDisplayName")
    }

    public var executableName: String? {
        string(forInfoDictionaryKey: "CFBundleExecutable")
    }

    public var version: String? {
        string(forInfoDictionaryKey: "CFBundleShortVersionString")
    }

    public var build: String? {
        string(forInfoDictionaryKey: "CFBundleVersion")
    }

    // MARK: - Instance Methods

    public func string(forInfoDictionaryKey key: String) -> String? {
        return object(forInfoDictionaryKey: key) as? String
    }

    public func url(forInfoDictionaryKey key: String) -> URL? {
        return string(forInfoDictionaryKey: key).flatMap(URL.init(string:))
    }
}
