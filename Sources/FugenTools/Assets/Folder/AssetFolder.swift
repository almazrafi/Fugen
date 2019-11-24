import Foundation
import PathKit

public struct AssetFolder {

    // MARK: - Type Methods

    public static func isValidFolder(at folderPath: String) -> Bool {
        return (try? AssetFolder(folderPath: folderPath)) != nil
    }

    // MARK: - Instance Properties

    public var colorSets: [String: AssetColorSet]
    public var folders: [String: AssetFolder]
    public var contents: AssetFolderContents

    // MARK: - Initializers

    public init(
        colorSets: [String: AssetColorSet] = [:],
        folders: [String: AssetFolder] = [:],
        contents: AssetFolderContents = AssetFolderContents()
    ) {
        self.colorSets = colorSets
        self.folders = folders
        self.contents = contents
    }

    public init(folderPath: String) throws {
        let folderPath = Path(folderPath)

        let contentsPath = folderPath.appending(.contentsPath)
        let contentsData = try contentsPath.read()
        let contentsDecoder = JSONDecoder()

        contents = try contentsDecoder.decode(from: contentsData)

        colorSets = [:]
        folders = [:]

        try folderPath
            .children()
            .lazy
            .filter { $0.isDirectory }
            .forEach { nodePath in
                let nodeName = nodePath.lastComponentWithoutExtension

                switch nodePath.extension {
                case String.colorSetPathExtension:
                    colorSets[nodeName] = try AssetColorSet(folderPath: nodePath.string)

                case nil:
                    folders[nodeName] = try AssetFolder(folderPath: nodePath.string)

                default:
                    break
                }
            }
    }

    // MARK: - Instance Methods

    private func saveColorSets(in  folderPath: Path) throws {
        try colorSets.forEach { colorSet in
            let colorSetPath = folderPath.appending(
                fileName: colorSet.key,
                extension: .colorSetPathExtension
            )

            try colorSet.value.save(in: colorSetPath.string)
        }
    }

    private func saveFolders(in folderPath: Path) throws {
        try folders.forEach { folder in
            try folder.value.save(in: folderPath.appending(folder.key).string)
        }
    }

    public func save(in folderPath: String) throws {
        let folderPath = Path(folderPath)

        if folderPath.exists {
            try folderPath.delete()
        }

        try folderPath.mkpath()

        try saveColorSets(in: folderPath)
        try saveFolders(in: folderPath)

        let contentsEncoder = JSONEncoder(outputFormatting: .prettyPrinted)
        let contentsData = try contentsEncoder.encode(contents)
        let contentsPath = folderPath.appending(.contentsPath)

        try contentsPath.write(contentsData)
    }
}

private extension String {

    // MARK: - Type Properties

    static let contentsPath = "Contents.json"
    static let colorSetPathExtension = "colorset"
}
