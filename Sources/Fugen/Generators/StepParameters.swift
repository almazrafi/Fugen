import Foundation

struct StepParameters {

    // MARK: - Instance Properties

    let fileKey: String
    let fileVersion: String?
    let includedNodes: [String]?
    let excludedNodes: [String]?

    let accessToken: String

    let template: RenderTemplate
    let destination: RenderDestination
}
