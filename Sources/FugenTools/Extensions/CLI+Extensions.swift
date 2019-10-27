import Foundation
import SwiftCLI

extension CLI {

    // MARK: - Instance Methods

    public func goAndExitOnError() {
        let result = go()

        if result != EXIT_SUCCESS {
            exit(result)
        }
    }
}
