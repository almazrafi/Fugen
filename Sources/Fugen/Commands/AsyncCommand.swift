import Foundation
import SwiftCLI
import Rainbow

protocol AsyncCommand: Command {

    // MARK: - Instance Methods

    func executeAndExit() throws

    func fail(message: String) -> Never
    func fail(error: Error) -> Never
    func succeed() -> Never
}

extension AsyncCommand {

    // MARK: - Instance Methods

    func execute() throws {
        try executeAndExit()

        RunLoop.main.run()
    }

    func fail(message: String) -> Never {
        stderr <<< "Failed with error: \(message)".red

        exit(EXIT_FAILURE)
    }

    func fail(error: Error) -> Never {
        fail(message: "\(error)")
    }

    func succeed() -> Never {
        stdout <<< "Generation completed successfully!".green

        exit(EXIT_SUCCESS)
    }
}
