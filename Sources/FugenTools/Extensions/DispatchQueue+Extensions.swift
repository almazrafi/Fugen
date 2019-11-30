import Foundation

extension DispatchQueue {

    // MARK: - Instance Methods

    public func async(flags: DispatchWorkItemFlags?, _ work: @escaping() -> Void) {
        if let flags = flags {
            async(flags: flags, execute: work)
        } else {
            async(execute: work)
        }
    }
}
