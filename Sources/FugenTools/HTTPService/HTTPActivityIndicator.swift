import Foundation

public protocol HTTPActivityIndicator: AnyObject {

    // MARK: - Instance Properties

    var activityCount: Int { get }

    // MARK: - Instance Methods

    func incrementActivityCount()
    func decrementActivityCount()
}
