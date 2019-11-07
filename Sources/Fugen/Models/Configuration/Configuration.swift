import Foundation

struct Configuration: Decodable {

    // MARK: - Instance Properties

    let base: StepConfiguration?

    let colorStyles: StepConfiguration?
    let textStyles: StepConfiguration?
}
