import Foundation

extension ProcessInfo {

    // MARK: - Instance Properties

    public var executablePath: String {
        arguments[0]
    }
}
