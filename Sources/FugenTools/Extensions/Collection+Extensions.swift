import Foundation

extension Collection {

    // MARK: - Instance Methods

    internal func contains(index: Index) -> Bool {
        return ((index >= startIndex) && (index < endIndex))
    }

    internal subscript(safe index: Index) -> Element? {
        return contains(index: index) ? self[index] : nil
    }
}
