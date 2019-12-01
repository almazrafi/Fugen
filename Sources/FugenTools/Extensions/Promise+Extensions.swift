import Foundation
import PromiseKit

extension Promise {

    // MARK: - Type Methods

    public static func error(_ error: Error) -> Promise<T> {
        return Promise(error: error)
    }

    // MARK: - Instance Methods

    public func nest<U: Thenable>(
        on queue: DispatchQueue? = conf.Q.map,
        flags: DispatchWorkItemFlags? = nil,
        _ body: @escaping(T) throws -> U
    ) -> Promise<T> {
        then(on: queue, flags: flags) { value in
            try body(value).map(on: nil) { _ in
                value
            }
        }
    }

    public func asOptional() -> Promise<T?> {
        return map(on: nil) { $0 as T? }
    }
}

public func perform<T>(
    on queue: DispatchQueue? = conf.Q.map,
    flags: DispatchWorkItemFlags? = nil,
    _ body: @escaping () throws -> T
) -> Promise<T> {
    return Promise<T> { seal in
        let work = {
            do {
                seal.fulfill(try body())
            } catch {
                seal.reject(error)
            }
        }

        if let queue = queue {
            queue.async(flags: flags, work)
        } else {
            work()
        }
    }
}
