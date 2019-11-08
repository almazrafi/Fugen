import Foundation

extension FloatingPoint {

    // MARK: - Instance Methods

    public func rounded(precision: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
        let scale = Self(precision * 10)

        return (self * scale).rounded(rule) / scale
    }
}
