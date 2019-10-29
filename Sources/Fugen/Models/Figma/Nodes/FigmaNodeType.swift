import Foundation

indirect enum FigmaNodeType: Hashable {

    // MARK: - Enumeration Cases

    case unknown
    case document(info: FigmaDocumentNodeInfo)
    case canvas(info: FigmaCanvasNodeInfo)
    case frame(info: FigmaFrameNodeInfo)
    case group(info: FigmaFrameNodeInfo)
    case vector(info: FigmaVectorNodeInfo)
    case booleanOperation(info: FigmaVectorNodeInfo, payload: FigmaBooleanOperationNodePayload)
    case star(info: FigmaVectorNodeInfo)
    case line(info: FigmaVectorNodeInfo)
    case ellipse(info: FigmaVectorNodeInfo)
    case regularPolygon(info: FigmaVectorNodeInfo)
    case rectangle(info: FigmaVectorNodeInfo, payload: FigmaRectangleNodePayload)
    case text(info: FigmaVectorNodeInfo, payload: FigmaTextNodePayload)
    case slice(info: FigmaSliceNodeInfo)
    case component(info: FigmaFrameNodeInfo)
    case instance(info: FigmaFrameNodeInfo, payload: FigmaInstanceNodePayload)
}
