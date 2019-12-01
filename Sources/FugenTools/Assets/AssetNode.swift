import Foundation
import PathKit

public protocol AssetNode {

    // MARK: - Nested Types

    associatedtype Contents: Codable

    // MARK: - Type Properties

    static var pathExtension: String { get }

    // MARK: - Instance Properties

    var contents: Contents { get set }

    // MARK: - Initializers

    init(contents: Contents)
    init(folderPath: String) throws

    // MARK: - Instance Methods

    func save(in folderPath: String) throws
}

extension AssetNode {

    // MARK: - Initializers

    public init(folderPath: String) throws {
        let folderPath = Path(folderPath)

        let contentsPath = folderPath.appending(.contentsPath)
        let contentsData = try contentsPath.read()
        let contentsDecoder = JSONDecoder()

        self.init(contents: try contentsDecoder.decode(from: contentsData))
    }

    // MARK: - Instance Methods

    public func save(in folderPath: String) throws {
        let folderPath = Path(folderPath)

        try folderPath.mkpath()

        let contentsEncoder = JSONEncoder(outputFormatting: .prettyPrinted)
        let contentsData = try contentsEncoder.encode(contents)
        let contentsPath = folderPath.appending(.contentsPath)

        try contentsPath.write(contentsData)
    }
}

private extension String {

    // MARK: - Type Properties

    static let contentsPath = "Contents.json"
}
