import Foundation

extension OperatingSystemVersion {

    // MARK: - Instance Properties

    public var fullVersion: String {
        guard patchVersion > 0 else {
            return "\(majorVersion).\(minorVersion)"
        }

        return "\(majorVersion).\(minorVersion).\(patchVersion)"
    }
}
