import PromiseKit

protocol GradientStylesGenerator {

    // MARK: - Instance Methods

    func generate(configuration: GradientStylesConfiguration) -> Promise<Void>
}
