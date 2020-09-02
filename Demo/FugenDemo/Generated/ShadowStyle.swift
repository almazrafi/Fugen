// swiftlint:disable all
// Generated using Fugen - https://github.com/almazrafi/Fugen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct Shadow: Equatable {

    // MARK: - Type Properties

    public static let clear = Shadow()

    /// Ugly Shadow 1
    ///
    /// Offset: x 2.0; y 2.0
    /// Radius: 8.0
    /// Color: hex #19193219; rgba 25 25 50, 10%
    /// Opacity: 0.10000000149011612
    public static let uglyShadow1 = Shadow(
        offset: CGSize(width: 2.0, height: 2.0),
        radius: 8.0,
        color: UIColor(
            red: 0.09803921729326245,
            green: 0.09803921729326245,
            blue: 0.19607843458652496,
            alpha: 1.0
        ),
        opacity: 0.10000000149011612
    )

    /// Card Shadow 1
    ///
    /// Offset: x 2.0; y 8.0
    /// Radius: 12.0
    /// Color: hex #32324619; rgba 50 50 70, 10%
    /// Opacity: 0.10000000149011612
    public static let cardShadow1 = Shadow(
        offset: CGSize(width: 2.0, height: 8.0),
        radius: 12.0,
        color: UIColor(
            red: 0.19607843458652496,
            green: 0.19607843458652496,
            blue: 0.27450981736183167,
            alpha: 1.0
        ),
        opacity: 0.10000000149011612
    )

    /// Card Shadow 2
    ///
    /// Offset: x 0.0; y 0.0
    /// Radius: 4.0
    /// Color: hex #19192319; rgba 25 25 35, 10%
    /// Opacity: 0.10000000149011612
    public static let cardShadow2 = Shadow(
        offset: CGSize(width: 0.0, height: 0.0),
        radius: 4.0,
        color: UIColor(
            red: 0.09803921729326245,
            green: 0.09803921729326245,
            blue: 0.13725490868091583,
            alpha: 1.0
        ),
        opacity: 0.10000000149011612
    )

    /// Thin Shadow 
    ///
    /// Offset: x 0.0; y 1.0
    /// Radius: 4.0
    /// Color: hex #19193219; rgba 25 25 50, 10%
    /// Opacity: 0.10000000149011612
    public static let thinShadow = Shadow(
        offset: CGSize(width: 0.0, height: 1.0),
        radius: 4.0,
        color: UIColor(
            red: 0.09803921729326245,
            green: 0.09803921729326245,
            blue: 0.19607843458652496,
            alpha: 1.0
        ),
        opacity: 0.10000000149011612
    )

    // MARK: - Instance Properties

    public let offset: CGSize
    public let radius: CGFloat
    public let color: UIColor?
    public let opacity: Float

    // MARK: - Initializers

    public init(
        offset: CGSize = CGSize(width: 0, height: -3),
        radius: CGFloat = 3.0,
        color: UIColor? = .black,
        opacity: Float = 0.0
    ) {
        self.offset = offset
        self.radius = radius
        self.color = color
        self.opacity = opacity
    }
}

public struct ShadowStyle {

    // MARK: - Type Properties

    public static let clear = ShadowStyle()

    /// Ugly Shadow
    public static let uglyShadow = ShadowStyle(
        shadows: [
            .uglyShadow1
        ]
    )

    /// Field Shadow
    public static let fieldShadow = ShadowStyle(
        shadows: [
        ]
    )

    /// Card Shadow
    public static let cardShadow = ShadowStyle(
        shadows: [
            .cardShadow1,
            .cardShadow2
        ]
    )

    /// Thin Shadow
    public static let thinShadow = ShadowStyle(
        shadows: [
            .thinShadow
        ]
    )

    // MARK: - Instance Properties

    public let shadows: [Shadow]

    // MARK: - Initializers

    public init(shadows: [Shadow] = []) {
        self.shadows = shadows
    }
}

public extension CALayer {

    // MARK: - Instance Properties

    var shadow: Shadow {
        get {
            Shadow(
                offset: shadowOffset,
                radius: shadowRadius,
                color: shadowColor.map(UIColor.init(cgColor:)),
                opacity: shadowOpacity
            )
        }

        set {
            shadowOffset = newValue.offset
            shadowRadius = newValue.radius
            shadowColor = newValue.color?.cgColor
            shadowOpacity = newValue.opacity
        }
    }

    // MARK: - Initializers

    convenience init(shadow: Shadow) {
        self.init()

        self.shadow = shadow
    }
}

public extension UIView {

    // MARK: - Instance Properties

    var shadow: Shadow {
        get { layer.shadow }
        set { layer.shadow = newValue }
    }
}

private extension UIBezierPath {

    // MARK: - Initializers

    convenience init(
        roundedRect rect: CGRect,
        byRoundingCorners layerCorners: CACornerMask,
        cornerRadii: CGSize
    ) {
        #if canImport(UIKit)
            let cornerMaskMap: KeyValuePairs<CACornerMask, UIRectCorner> = [
                .layerMinXMinYCorner: .topLeft,
                .layerMinXMaxYCorner: .bottomLeft,
                .layerMaxXMinYCorner: .topRight,
                .layerMaxXMaxYCorner: .bottomRight
            ]

            let rectCorners = cornerMaskMap
                .lazy
                .filter { layerCorners.contains($0.key) }
                .reduce(into: UIRectCorner()) { result, corner in
                    result.insert(corner.value)
                }

            self.init(
                roundedRect: rect,
                byRoundingCorners: rectCorners,
                cornerRadii: cornerRadii
            )
        #else
            self.init(
                roundedRect: NSRectFromCGRect(rect),
                xRadius: cornerRadii.width,
                yRadius: cornerRadii.height
            )
        #endif
    }
}

open class ShadowStyleLayer: CALayer {

    // MARK: - Instance Properties

    private var shadowLayers: [CALayer] = []
    private let backgroundLayer = CALayer()

    public var shadowStyle: ShadowStyle {
        didSet { updateShadowLayers() }
    }

    public override var backgroundColor: CGColor? {
        get { backgroundLayer.backgroundColor }
        set { backgroundLayer.backgroundColor = newValue }
    }

    public override var cornerRadius: CGFloat {
        didSet { backgroundLayer.cornerRadius = cornerRadius }
    }

    public override var maskedCorners: CACornerMask {
        didSet { backgroundLayer.maskedCorners = maskedCorners }
    }

    // MARK: - Initializers

    public init(shadowStyle: ShadowStyle) {
        self.shadowStyle = shadowStyle

        super.init()

        configureShadowLayers()
        configureBackgroundLayer()
    }

    public override convenience init() {
        self.init(shadowStyle: .clear)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance Methods

    private func configureShadowLayers() {
        shadowLayers = shadowStyle
            .shadows
            .map { CALayer(shadow: $0) }

        shadowLayers.reversed().forEach { shadowLayer in
            insertSublayer(shadowLayer, at: 0)
        }
    }

    private func configureBackgroundLayer() {
        backgroundLayer.masksToBounds = true

        addSublayer(backgroundLayer)
    }

    private func updateShadowLayers() {
        shadowLayers.forEach { $0.removeFromSuperlayer() }

        configureShadowLayers()
    }

    private func layoutShadowLayers() {
        shadowLayers.forEach { shadowLayer in
            shadowLayer.frame = bounds

            shadowLayer.shadowPath = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: maskedCorners,
                cornerRadii: CGSize(
                    width: cornerRadius,
                    height: cornerRadius
                )
            ).cgPath
        }
    }

    private func layoutBackgroundLayer() {
        backgroundLayer.frame = bounds
    }

    open override func layoutSublayers() {
        super.layoutSublayers()

        layoutShadowLayers()
        layoutBackgroundLayer()
    }
}

open class ShadowStyleView: UIView {

    // MARK: - Type Properties

    public override class var layerClass: AnyClass {
        ShadowStyleLayer.self
    }

    // MARK: - Instance Properties

    public var shadowStyleLayer: ShadowStyleLayer {
        layer as! ShadowStyleLayer
    }

    public var shadowStyle: ShadowStyle {
        get { shadowStyleLayer.shadowStyle }
        set { shadowStyleLayer.shadowStyle = newValue }
    }

    public override var backgroundColor: UIColor? {
        get { shadowStyleLayer.backgroundColor.map(UIColor.init(cgColor:)) }
        set { shadowStyleLayer.backgroundColor = newValue?.cgColor }
    }
}
