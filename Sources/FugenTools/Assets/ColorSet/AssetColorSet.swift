import Foundation
import PathKit

public struct AssetColorSet {

    // MARK: - Type Methods

    public static func isValidColorSet(at folderPath: String) -> Bool {
        return (try? AssetColorSet(folderPath: folderPath)) != nil
    }

    // MARK: - Instance Properties

    public var contents: AssetColorSetContents

    // MARK: - Initializers

    public init(contents: AssetColorSetContents = AssetColorSetContents()) {
        self.contents = contents
    }

    public init(folderPath: String) throws {
        let folderPath = Path(folderPath)

        let contentsPath = folderPath.appending(.contentsPath)
        let contentsData = try contentsPath.read()
        let contentsDecoder = JSONDecoder()

        contents = try contentsDecoder.decode(from: contentsData)
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
