// swiftlint:disable all
// Generated using Fugen: https://github.com/almazrafi/Fugen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public struct TextStyle: Equatable {

    // MARK: - Type Properties

    /// Footnote
    ///
    /// Font: Roboto (Roboto-Regular); weight 400.0; size 11.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 12.9
    /// Letter spacing: 0.0
    public static let footnote = TextStyle(
        fontName: "Roboto-Regular",
        fontSize: 11.0,
        color: UIColor(
            red: 0.22352941,
            green: 0.22352941,
            blue: 0.22352941,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 12.9,
        letterSpacing: 0.0
    )

    /// Body
    ///
    /// Font: Roboto (Roboto-Regular); weight 400.0; size 13.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 15.225
    /// Letter spacing: 0.0
    public static let body = TextStyle(
        fontName: "Roboto-Regular",
        fontSize: 13.0,
        color: UIColor(
            red: 0.22352941,
            green: 0.22352941,
            blue: 0.22352941,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 15.225,
        letterSpacing: 0.0
    )

    /// Subtitle
    ///
    /// Font: Roboto (Roboto-Medium); weight 500.0; size 14.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 16.4
    /// Letter spacing: 0.0
    public static let subtitle = TextStyle(
        fontName: "Roboto-Medium",
        fontSize: 14.0,
        color: UIColor(
            red: 0.22352941,
            green: 0.22352941,
            blue: 0.22352941,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 16.4,
        letterSpacing: 0.0
    )

    /// Title
    ///
    /// Font: Roboto (Roboto-Regular); weight 400.0; size 18.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 21.1
    /// Letter spacing: 0.0
    public static let title = TextStyle(
        fontName: "Roboto-Regular",
        fontSize: 18.0,
        color: UIColor(
            red: 0.22352941,
            green: 0.22352941,
            blue: 0.22352941,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 21.1,
        letterSpacing: 0.0
    )

    /// Large Title
    ///
    /// Font: Roboto (Roboto-Regular); weight 400.0; size 30.0
    /// Color: Eclipse; hex #393939FF; rgba 57 57 57, 100%
    /// Strikethrough: false
    /// Underline: false
    /// Paragraph spacing: default
    /// Paragraph indent: default
    /// Line height: 35.15
    /// Letter spacing: 0.0
    public static let largeTitle = TextStyle(
        fontName: "Roboto-Regular",
        fontSize: 30.0,
        color: UIColor(
            red: 0.22352941,
            green: 0.22352941,
            blue: 0.22352941,
            alpha: 1.0
        ),
        strikethrough: false,
        underline: false,
        paragraphSpacing: nil,
        paragraphIndent: nil,
        lineHeight: 35.15,
        letterSpacing: 0.0
    )

    // MARK: - Instance Properties

    public let font: UIFont
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

    public var actualLineHeight: CGFloat {
        return lineHeight ?? font.lineHeight
    }

    // MARK: - Initializers

    public init(
        font: UIFont,
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

    public init(
        fontName: String,
        fontSize: CGFloat,
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
        let font = UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)

        self.init(
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

    // MARK: - Instance Methods

    private func attributes(paragraphStyle: NSParagraphStyle?) -> [NSAttributedString.Key: Any] {
        var attributes: [NSAttributedString.Key: Any] = [.font: font]

        if let paragraphStyle = paragraphStyle {
            attributes[.paragraphStyle] = paragraphStyle
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

    public func paragraphStyle() -> NSParagraphStyle {
        let paragraphStyle = NSMutableParagraphStyle()

        if let lineHeight = lineHeight {
            let paragraphLineSpacing = (lineHeight - font.lineHeight) * 0.5
            let paragraphLineHeight = lineHeight - paragraphLineSpacing

            paragraphStyle.lineSpacing = paragraphLineSpacing
            paragraphStyle.minimumLineHeight = paragraphLineHeight
            paragraphStyle.maximumLineHeight = paragraphLineHeight
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

    public func withFont(_ font: UIFont) -> TextStyle {
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
// swiftlint:enable all
