// swiftlint:disable all
// Generated using Fugen - https://github.com/almazrafi/Fugen

#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct TextStyle: Equatable {

    // MARK: - Nested Types

    public enum ValidationError: Error, CustomStringConvertible {
        case fontNotFound(name: String, size: Double)

        public var description: String {
            switch self {
            case let .fontNotFound(name, size):
                return "Font '\(name) \(size)' couldn't be loaded"
            }
        }
    }

    // MARK: - Type Properties

    /// Caption
    ///
    /// Font: SF Pro Display (SFProDisplay-Light); weight 300.0; size 13.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 15.225
    /// Letter spacing: 0.0
    public static let caption = TextStyle(
        font: UIFont(name: "SFProDisplay-Light", size: 13.0),
        color: UIColor(
            red: 0.2235294133424759,
            green: 0.2235294133424759,
            blue: 0.2235294133424759,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 15.225,
        letterSpacing: 0.0
    )

    /// Body
    ///
    /// Font: SF Pro Display (SFProDisplay-Regular); weight 400.0; size 13.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: 4.0
    /// Paragraph indent: 16.0
    /// Line height: 16.0
    /// Letter spacing: 0.125
    public static let body = TextStyle(
        font: UIFont(name: "SFProDisplay-Regular", size: 13.0),
        color: UIColor(
            red: 0.2235294133424759,
            green: 0.2235294133424759,
            blue: 0.2235294133424759,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: 4.0,
        paragraphIndent: 16.0,
        lineHeight: 16.0,
        letterSpacing: 0.125
    )

    /// Subtitle
    ///
    /// Font: SF Pro Display (SFProDisplay-Regular); weight 400.0; size 15.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 17.575
    /// Letter spacing: 0.2
    public static let subtitle = TextStyle(
        font: UIFont(name: "SFProDisplay-Regular", size: 15.0),
        color: UIColor(
            red: 0.2235294133424759,
            green: 0.2235294133424759,
            blue: 0.2235294133424759,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 17.575,
        letterSpacing: 0.2
    )

    /// Title
    ///
    /// Font: SF Pro Display (SFProDisplay-Medium); weight 500.0; size 17.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 19.925
    /// Letter spacing: 0.125
    public static let title = TextStyle(
        font: UIFont(name: "SFProDisplay-Medium", size: 17.0),
        color: UIColor(
            red: 0.2235294133424759,
            green: 0.2235294133424759,
            blue: 0.2235294133424759,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 19.925,
        letterSpacing: 0.125
    )

    /// Large Title
    ///
    /// Font: SF Pro Display (SFProDisplay-Bold); weight 700.0; size 34.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 39.85
    /// Letter spacing: 0.1
    public static let largeTitle = TextStyle(
        font: UIFont(name: "SFProDisplay-Bold", size: 34.0),
        color: UIColor(
            red: 0.2235294133424759,
            green: 0.2235294133424759,
            blue: 0.2235294133424759,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 39.85,
        letterSpacing: 0.1
    )

    // MARK: - Type Methods

    public static func validate() throws {
        guard UIFont(name: "SFProDisplay-Light", size: 13.0) != nil else {
            throw ValidationError.fontNotFound(name: "SFProDisplay-Light", size: 13.0)
        }

        guard UIFont(name: "SFProDisplay-Regular", size: 13.0) != nil else {
            throw ValidationError.fontNotFound(name: "SFProDisplay-Regular", size: 13.0)
        }

        guard UIFont(name: "SFProDisplay-Regular", size: 15.0) != nil else {
            throw ValidationError.fontNotFound(name: "SFProDisplay-Regular", size: 15.0)
        }

        guard UIFont(name: "SFProDisplay-Medium", size: 17.0) != nil else {
            throw ValidationError.fontNotFound(name: "SFProDisplay-Medium", size: 17.0)
        }

        guard UIFont(name: "SFProDisplay-Bold", size: 34.0) != nil else {
            throw ValidationError.fontNotFound(name: "SFProDisplay-Bold", size: 34.0)
        }

        print("All text styles are valid")
    }

    // MARK: - Instance Properties

    public let font: UIFont?
    public let color: UIColor?
    public let backgroundColor: UIColor?
    public let strikethrough: Bool
    public let underline: Bool
    public let paragraphSpacing: CGFloat?
    public let paragraphIndent: CGFloat?
    public let lineHeight: CGFloat?
    public let letterSpacing: CGFloat?
    public let lineBreakMode: NSLineBreakMode?
    public let alignment: NSTextAlignment?

    // MARK: - Initializers

    public init(
        font: UIFont? = nil,
        color: UIColor? = nil,
        backgroundColor: UIColor? = nil,
        strikethrough: Bool = false,
        underline: Bool = false,
        paragraphSpacing: CGFloat? = nil,
        paragraphIndent: CGFloat? = nil,
        lineHeight: CGFloat? = nil,
        letterSpacing: CGFloat? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        alignment: NSTextAlignment? = nil
    ) {
        self.font = font
        self.color = color
        self.backgroundColor = backgroundColor
        self.strikethrough = strikethrough
        self.underline = underline
        self.paragraphSpacing = paragraphSpacing
        self.paragraphIndent = paragraphIndent
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
        self.lineBreakMode = lineBreakMode
        self.alignment = alignment
    }

    // MARK: - Instance Methods

    private func attributes(paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [:]

        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
        }

        if let font = font {
            attributes[.font] = font
        }

        if let color = color {
            attributes[.foregroundColor] = color
        }

        if let backgroundColor = backgroundColor {
            attributes[.backgroundColor] = backgroundColor
        }

        if strikethrough {
            attributes[.strikethroughStyle] = NSUnderlineStyle.single.rawValue
        }

        if underline {
            attributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
        }

        if let letterSpacing = letterSpacing {
            attributes[.kern] = letterSpacing
        }

        return attributes
    }

    // MARK: -

    public func paragraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = lineHeight {
            if let font = font {
                paragraphStyle.lineSpacing = (lineHeight - font.lineHeight) * 0.5
                paragraphStyle.minimumLineHeight = lineHeight - paragraphStyle.lineSpacing
            } else {
                paragraphStyle.lineSpacing = 0.0
                paragraphStyle.minimumLineHeight = lineHeight
            }

            paragraphStyle.maximumLineHeight = paragraphStyle.minimumLineHeight
        }

        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }

        if let paragraphIndent = paragraphIndent {
            paragraphStyle.firstLineHeadIndent = paragraphIndent
        }

        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }

        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }

        return paragraphStyle
    }

    public func attributes(includingParagraphStyle: Bool = true) -> [NSAttributedString.Key: Any] {
        if includingParagraphStyle {
            return attributes(paragraphStyle: paragraphStyle())
        } else {
            return attributes(paragraphStyle: nil)
        }
    }

    public func attributedString(
        _ string: String,
        includingParagraphStyle: Bool = true
    ) -> NSAttributedString {
        return NSAttributedString(string: string, style: self, includingParagraphStyle: includingParagraphStyle)
    }

    // MARK: -

    public func withFont(_ font: UIFont?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withColor(_ color: UIColor?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withBackgroundColor(_ backgroundColor: UIColor?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withStrikethrough(_ strikethrough: Bool) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withUnderline(_ underline: Bool) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withParagraphSpacing(_ paragraphSpacing: CGFloat?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withParagraphIndent(_ paragraphIndent: CGFloat?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLineHeight(_ lineHeight: CGFloat?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLetterSpacing(_ letterSpacing: CGFloat?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withLineBreakMode(_ lineBreakMode: NSLineBreakMode?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }

    public func withAlignment(_ alignment: NSTextAlignment?) -> TextStyle {
        return TextStyle(
            font: font,
            color: color,
            backgroundColor: backgroundColor,
            strikethrough: strikethrough,
            underline: underline,
            paragraphSpacing: paragraphSpacing,
            paragraphIndent: paragraphIndent,
            lineHeight: lineHeight,
            letterSpacing: letterSpacing,
            lineBreakMode: lineBreakMode,
            alignment: alignment
        )
    }
}

public extension NSAttributedString {

    // MARK: - Initializers

    convenience init(string: String, style: TextStyle, includingParagraphStyle: Bool = true) {
        self.init(string: string, attributes: style.attributes(includingParagraphStyle: includingParagraphStyle))
    }
}
