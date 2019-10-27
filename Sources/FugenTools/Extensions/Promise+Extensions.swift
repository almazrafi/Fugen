import Foundation
import PromiseKit

extension Promise {

    // MARK: - Type Methods

    public static func error(_ error: Error) -> Promise<T> {
        return Promise(error: error)
    }
}
