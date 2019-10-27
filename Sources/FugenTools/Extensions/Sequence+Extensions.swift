import Foundation

extension Sequence {

    // MARK: - Instance Properties

    public var lazyFirst: Element? {
        first { _ in true }
    }
}
