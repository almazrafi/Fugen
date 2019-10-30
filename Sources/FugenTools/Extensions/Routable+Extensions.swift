import Foundation
import SwiftCLI
import Rainbow

extension Routable {

    // MARK: - Instance Methods

    public func fail(message: String) -> Never {
        stderr <<< "Failed with error: \(message)".red

        exit(EXIT_FAILURE)
    }

    public func fail(error: Error) -> Never {
        fail(message: "\(error)")
    }

    public func success(message: String? = nil) -> Never {
        if let message = message {
            stdout <<< message.green
        }

        exit(EXIT_SUCCESS)
    }
}
