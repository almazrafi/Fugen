import Foundation

final class StencilStyleNameFilter: StencilFilter {

    // MARK: - Instance Properties

    let name = "styleName"

    // MARK: - Instance Methods

    func filter(input: String) throws -> String {
        let separated = input.components(separatedBy: "/")

        guard separated.count == 2 else {
            return input
        }

        let styleGroupName = separated[0]
        let styleName = separated[1]

        return styleGroupName + styleName.replacingOccurrences(of: styleGroupName, with: "")
    }
}
