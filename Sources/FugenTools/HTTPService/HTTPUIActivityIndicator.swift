#if canImport(UIKit)
import UIKit

public final class HTTPUIActivityIndicator: WebActivityIndicator {

    // MARK: - Type Properties

    public static let shared = WebUIActivityIndicator()

    // MARK: - Instance Properties

    public private(set) var activityCount = 0 {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = activityCount > 0
        }
    }

    // MARK: - Initializers

    private init() { }

    // MARK: - Instance Methods

    public func resetActivityCount() {
        activityCount = 0
    }

    // MARK: - WebActivityIndicator

    public func incrementActivityCount() {
        activityCount += 1
    }

    public func decrementActivityCount() {
        if activityCount > 0 {
            activityCount -= 1
        }
    }
}
#endif
