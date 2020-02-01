import Foundation

extension Collection {

    // MARK: - Instance Methods

    public func contains(index: Index) -> Bool {
        return ((index >= startIndex) && (index < endIndex))
    }

    public subscript(safe index: Index) -> Element? {
        return contains(index: index) ? self[index] : nil
    }
}
