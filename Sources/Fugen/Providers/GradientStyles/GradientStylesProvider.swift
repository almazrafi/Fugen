import PromiseKit

protocol GradientStylesProvider {

    // MARK: - Instance Methods

    func fetchGradientStyles(from file: FileParameters, nodes: NodesParameters) -> Promise<[GradientStyle]>
}
