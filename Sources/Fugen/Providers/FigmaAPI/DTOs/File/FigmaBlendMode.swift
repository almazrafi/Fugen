import Foundation

enum FigmaBlendMode: String {

    // MARK: - Enumeration Cases

    case passThrough = "PASS_THROUGH"
    case normal = "NORMAL"

    case darken = "DARKEN"
    case multiply = "MULTIPLY"
    case linearBurn = "LINEAR_BURN"
    case colorBurn = "COLOR_BURN"

    case lighten = "LIGHTEN"
    case screen = "SCREEN"
    case linearDodge = "LINEAR_DODGE"
    case colorDodge = "COLOR_DODGE"

    case overlay = "OVERLAY"
    case softLight = "SOFT_LIGHT"
    case hardLight = "HARD_LIGHT"

    case difference = "DIFFERENCE"
    case exclusion = "EXCLUSION"

    case hue = "HUE"
    case saturation = "SATURATION"
    case color = "COLOR"
    case luminosity = "LUMINOSITY"
}
