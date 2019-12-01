import Foundation

public enum AssetCompressionType: String, Codable {

    // MARK: - Enumeration Cases

    case automatic
    case lossless
    case basic = "lossy"
    case gpuBestQuality = "gpu-optimized-best"
    case gpuSmallestSize = "gpu-optimized-smallest"
}
