import Foundation
import PathKit

public struct AssetFolder {

    // MARK: - Type Methods

    public static func isValidFolder(at folderPath: String) -> Bool {
        return (try? AssetFolder(folderPath: folderPath)) != nil
    }

    // MARK: - Instance Properties

    public var colorSets: [String: AssetColorSet]
    public var imageSets: [String: AssetImageSet]
    public var folders: [String: AssetFolder]
    public var contents: AssetFolderContents

    // MARK: - Initializers

    public init(
        colorSets: [String: AssetColorSet] = [:],
        imageSets: [String: AssetImageSet] = [:],
        folders: [String: AssetFolder] = [:],
        contents: AssetFolderContents = AssetFolderContents()
    ) {
        self.colorSets = colorSets
        self.imageSets = imageSets
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
        imageSets = [:]
        folders = [:]

        try folderPath
            .children()
            .lazy
            .filter { $0.isDirectory }
            .forEach { nodePath in
                let nodeName = nodePath.lastComponentWithoutExtension

                switch nodePath.extension {
                case AssetColorSet.pathExtension:
                    colorSets[nodeName] = try AssetColorSet(folderPath: nodePath.string)

                case AssetImageSet.pathExtension:
                    imageSets[nodeName] = try AssetImageSet(folderPath: nodePath.string)

                case nil:
                    folders[nodeName] = try AssetFolder(folderPath: nodePath.string)

                default:
                    break
                }
            }
    }

    // MARK: - Instance Methods

    private func saveNodes<T: AssetNode>(_ nodes: [String: T], in folderPath: Path) throws {
        try nodes.forEach { node in
            let nodePath = folderPath.appending(
                fileName: node.key,
                extension: T.pathExtension
            )

            try node.value.save(in: nodePath.string)
        }
    }

    private func saveFolders(in folderPath: Path) throws {
        try folders.forEach { folder in
            try folder.value.save(in: folderPath.appending(folder.key).string)
        }
    }

    // MARK: -

    public func save(in folderPath: String) throws {
        let folderPath = Path(folderPath)

        if folderPath.exists {
            try folderPath.delete()
        }

        try folderPath.mkpath()

        try saveNodes(colorSets, in: folderPath)
        try saveNodes(imageSets, in: folderPath)
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
}
