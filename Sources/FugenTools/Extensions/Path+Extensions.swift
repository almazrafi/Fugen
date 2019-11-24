import Foundation
import PathKit

extension Path {

    // MARK: - Instance Methods

    public func appending(_ path: Path) -> Path {
        return self + path
    }

    public func appending(_ path: String) -> Path {
        return self + path
    }

    public func appending(fileName: String, `extension`: String) -> Path {
        return self + "\(fileName).\(`extension`)"
    }
}
