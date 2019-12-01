import Foundation

public struct AssetImageProperties: Codable, Hashable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case templateRenderingIntent = "template-rendering-intent"
        case preserveVectorRepresentation = "preserves-vector-representation"
        case autoScaling = "auto-scaling"
        case compressionType = "compression-type"
        case providesNamespace = "provides-namespace"
        case onDemandResourceTags = "on-demand-resource-tags"
    }

    // MARK: - Instance Properties

    public var templateRenderingIntent: AssetImageTemplateRenderingIntent?
    public var preserveVectorRepresentation: Bool?
    public var autoScaling: AssetImageAutoScaling?
    public var compressionType: AssetCompressionType?
    public var providesNamespace: Bool?
    public var onDemandResourceTags: [String]?

    // MARK: - Initializers

    public init(
        templateRenderingIntent: AssetImageTemplateRenderingIntent? = nil,
        preserveVectorRepresentation: Bool? = nil,
        autoScaling: AssetImageAutoScaling? = nil,
        compressionType: AssetCompressionType? = nil,
        providesNamespace: Bool? = nil,
        onDemandResourceTags: [String]? = nil
    ) {
        self.templateRenderingIntent = templateRenderingIntent
        self.preserveVectorRepresentation = preserveVectorRepresentation
        self.autoScaling = autoScaling
        self.compressionType = compressionType
        self.providesNamespace = providesNamespace
        self.onDemandResourceTags = onDemandResourceTags
    }
}
