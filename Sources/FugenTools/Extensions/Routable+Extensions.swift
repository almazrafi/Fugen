import Foundation
import SwiftCLI
import Rainbow

extension Routable {

    // MARK: - Instance Methods

    public func fail(message: String) -> Never {
        stderr <<< message.red

        exit(EXIT_FAILURE)
    }

    public func fail(error: Error) -> Never {
        fail(message: "Failed with error: \(error)")
    }

    public func success(message: String? = nil) -> Never {
        if let message = message {
            stdout <<< message.green
        }

        exit(EXIT_SUCCESS)
    }
}
