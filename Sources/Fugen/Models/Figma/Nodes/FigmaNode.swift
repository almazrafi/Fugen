import Foundation

struct FigmaNode: Decodable {

    // MARK: - Nested Types

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case type
        case isVisible = "visible"
    }

    private enum CodingValues {
        static let documentType = "DOCUMENT"
        static let canvasType = "CANVAS"
        static let frameType = "FRAME"
        static let groupType = "GROUP"
        static let vectorType = "VECTOR"
        static let booleanOperationType = "BOOLEAN_OPERATION"
        static let starType = "STAR"
        static let lineType = "LINE"
        static let ellipseType = "ELLIPSE"
        static let regularPolygonType = "REGULAR_POLYGON"
        static let rectangleType = "RECTANGLE"
        static let textType = "TEXT"
        static let sliceType = "SLICE"
        static let componentType = "COMPONENT"
        static let instanceType = "INSTANCE"
    }

    // MARK: - Instance Properties

    let id: String
    let name: String
    let type: FigmaNodeType
    let isVisible: Bool?

    // MARK: - Initializers

    init(from decoder: Decoder) throws {
        // swiftlint:disable:previous function_body_length

        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(forKey: .id)
        name = try container.decode(forKey: .name)

        isVisible = try container.decodeIfPresent(forKey: .isVisible)

        switch try container.decode(String.self, forKey: .type) {
        case CodingValues.documentType:
            type = .document(info: try FigmaDocumentNodeInfo(from: decoder))

        case CodingValues.canvasType:
            type = .canvas(info: try FigmaCanvasNodeInfo(from: decoder))

        case CodingValues.frameType:
            type = .frame(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.groupType:
            type = .group(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.vectorType:
            type = .vector(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.booleanOperationType:
            type = .booleanOperation(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaBooleanOperationNodePayload(from: decoder)
            )

        case CodingValues.starType:
            type = .star(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.lineType:
            type = .line(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.ellipseType:
            type = .ellipse(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.regularPolygonType:
            type = .regularPolygon(info: try FigmaVectorNodeInfo(from: decoder))

        case CodingValues.rectangleType:
            type = .rectangle(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaRectangleNodePayload(from: decoder)
            )

        case CodingValues.textType:
            type = .text(
                info: try FigmaVectorNodeInfo(from: decoder),
                payload: try FigmaTextNodePayload(from: decoder)
            )

        case CodingValues.sliceType:
            type = .slice(info: try FigmaSliceNodeInfo(from: decoder))

        case CodingValues.componentType:
            type = .component(info: try FigmaFrameNodeInfo(from: decoder))

        case CodingValues.instanceType:
            type = .instance(
                info: try FigmaFrameNodeInfo(from: decoder),
                payload: try FigmaInstanceNodePayload(from: decoder))

        default:
            type = .unknown
        }
    }
}
