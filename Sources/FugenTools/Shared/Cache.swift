import Foundation

public final class Cache<Key: Hashable, Value> {

    // MARK: - Instance Properties

    private let wrapped = NSCache<CacheKey<Key>, CacheValue<Value>>()

    // MARK: - Initializers

    public init() { }

    // MARK: - Instance Methods

    public func value(forKey key: Key) -> Value? {
        return wrapped.object(forKey: CacheKey(key))?.value
    }

    public func setValue(_ value: Value, forKey key: Key) {
        wrapped.setObject(CacheValue(value), forKey: CacheKey(key))
    }

    public func removeValue(forKey key: Key) {
        wrapped.removeObject(forKey: CacheKey(key))
    }
}

private final class CacheKey<T: Hashable>: NSObject {

    // MARK: - Instance Properties

    let key: T

    override var hash: Int {
        key.hashValue
    }

    // MARK: - Initializers

    init(_ key: T) {
        self.key = key
    }

    // MARK: - Instance Methods

    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? CacheKey<T> else {
            return false
        }

        return key == object.key
    }
}

private final class CacheValue<T> {

    // MARK: - Instance Properties

    let value: T

    // MARK: - Initializers

    init(_ value: T) {
        self.value = value
    }
}
