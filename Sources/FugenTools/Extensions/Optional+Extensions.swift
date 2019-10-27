import Foundation

extension Optional {

    // MARK: - Instance Properties

    public var isNil: Bool {
        self == nil
    }
}

extension Optional where Wrapped: Collection {

    // MARK: - Instance Properties

    public var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }
}
