import Foundation

extension RangeReplaceableCollection {

    // MARK: - Instance Methods

    public mutating func prepend<T: Collection>(contentsOf collection: T) where Self.Element == T.Element {
        insert(contentsOf: collection, at: startIndex)
    }

    public mutating func prepend(_ element: Element) {
        insert(element, at: startIndex)
    }

    public func prepending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        return collection + self
    }

    public func prepending(_ element: Element) -> Self {
        return prepending(contentsOf: [element])
    }

    public func appending<T: Collection>(contentsOf collection: T) -> Self where Self.Element == T.Element {
        return self + collection
    }

    public func appending(_ element: Element) -> Self {
        return appending(contentsOf: [element])
    }
}
