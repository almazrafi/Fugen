// swiftlint:disable all
// Generated using Fugen: https://github.com/almazrafi/Fugen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct ColorStyle: Equatable {

    // MARK: - Type Properties

    /// Whisper
    ///
    /// Hex #E9E9E9FF; rgba 233 233 233, 100%
    public static let whisper = ColorStyle(
        red: 0.9137255,
        green: 0.9137255,
        blue: 0.9137255,
        alpha: 1.0
    )

    /// Snow Drift
    ///
    /// Hex #DADAD9FF; rgba 218 218 217, 100%
    public static let snowDrift = ColorStyle(
        red: 0.85490197,
        green: 0.85490197,
        blue: 0.8509804,
        alpha: 1.0
    )

    /// Submarine
    ///
    /// Hex #949798FF; rgba 148 151 152, 100%
    public static let submarine = ColorStyle(
        red: 0.5803922,
        green: 0.5921569,
        blue: 0.59607846,
        alpha: 1.0
    )

    /// Eclipse
    ///
    /// Hex #393939FF; rgba 57 57 57, 100%
    public static let eclipse = ColorStyle(
        red: 0.22352941,
        green: 0.22352941,
        blue: 0.22352941,
        alpha: 1.0
    )

    /// Lochinvar
    ///
    /// Hex #42967DFF; rgba 66 150 125, 100%
    public static let lochinvar = ColorStyle(
        red: 0.25882354,
        green: 0.5882353,
        blue: 0.49019608,
        alpha: 1.0
    )

    /// Jelly Bean
    ///
    /// Hex #427D96FF; rgba 66 125 150, 100%
    public static let jellyBean = ColorStyle(
        red: 0.25882354,
        green: 0.49019608,
        blue: 0.5882353,
        alpha: 1.0
    )

    /// Daisy Bush
    ///
    /// Hex #5B4296FF; rgba 91 66 150, 100%
    public static let daisyBush = ColorStyle(
        red: 0.35686275,
        green: 0.25882354,
        blue: 0.5882353,
        alpha: 1.0
    )

    /// Razzmatazz
    ///
    /// Hex #E30B5CFF; rgba 227 11 92, 100%
    public static let razzmatazz = ColorStyle(
        red: 0.8901961,
        green: 0.043137256,
        blue: 0.36078432,
        alpha: 1.0
    )

    // MARK: - Instance Properties

    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat

    public var color: UIColor {
        return UIColor(style: self)
    }

    // MARK: - Initializers

    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    // MARK: - Instance Methods

    public func withRed(_ red: CGFloat) -> ColorStyle {
        return ColorStyle(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }

    public func withGreen(_ green: CGFloat) -> ColorStyle {
        return ColorStyle(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }

    public func withBlue(_ blue: CGFloat) -> ColorStyle {
        return ColorStyle(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }

    public func withAlpha(_ alpha: CGFloat) -> ColorStyle {
        return ColorStyle(
            red: red,
            green: green,
            blue: blue,
            alpha: alpha
        )
    }
}

public extension UIColor {

    // MARK: - Initializers

    convenience init(style: ColorStyle) {
        self.init(red: style.red, green: style.green, blue: style.blue, alpha: style.alpha)
    }
}
// swiftlint:enable all
