// swiftlint:disable all
// Generated using Fugen - https://github.com/almazrafi/Fugen
#if canImport(UIKit)
import UIKit
#else
import AppKit
#endif

public enum Images {

    // MARK: - Nested Types

    public enum ValidationError: Error, CustomStringConvertible {
        case assetNotFound(name: String)
        case resourceNotFound(name: String)

        public var description: String {
            switch self {
            case let .assetNotFound(name):
                return "Image asset '\(name)' couldn't be loaded"

            case let .resourceNotFound(name):
                return "Image resource file '\(name)' couldn't be loaded"
            }
        }
    }

    // MARK: - Type Properties

    /// WeChat
    ///
    /// Asset: WeChat
    public static var weChat: UIImage {
        return UIImage(named: "WeChat")!
    }

    /// Snapchat
    ///
    /// Asset: Snapchat
    public static var snapchat: UIImage {
        return UIImage(named: "Snapchat")!
    }

    /// Viber
    ///
    /// Asset: Viber
    public static var viber: UIImage {
        return UIImage(named: "Viber")!
    }

    /// WhatsApp
    ///
    /// Asset: WhatsApp
    public static var whatsApp: UIImage {
        return UIImage(named: "WhatsApp")!
    }

    /// Telegram
    ///
    /// Asset: Telegram
    public static var telegram: UIImage {
        return UIImage(named: "Telegram")!
    }

    /// Cloud
    ///
    /// Asset: Cloud
    public static var cloud: UIImage {
        return UIImage(named: "Cloud")!
    }

    /// Phone
    ///
    /// Asset: Phone
    public static var phone: UIImage {
        return UIImage(named: "Phone")!
    }

    /// Share
    ///
    /// Asset: Share
    public static var share: UIImage {
        return UIImage(named: "Share")!
    }

    /// Star
    ///
    /// Asset: Star
    public static var star: UIImage {
        return UIImage(named: "Star")!
    }

    /// Geo
    ///
    /// Asset: Geo
    public static var geo: UIImage {
        return UIImage(named: "Geo")!
    }

    // MARK: - Type Methods

    public static func validate() throws {
        guard UIImage(named: "WeChat") != nil else {
            throw ValidationError.assetNotFound(name: "WeChat")
        }

        guard UIImage(named: "Snapchat") != nil else {
            throw ValidationError.assetNotFound(name: "Snapchat")
        }

        guard UIImage(named: "Viber") != nil else {
            throw ValidationError.assetNotFound(name: "Viber")
        }

        guard UIImage(named: "WhatsApp") != nil else {
            throw ValidationError.assetNotFound(name: "WhatsApp")
        }

        guard UIImage(named: "Telegram") != nil else {
            throw ValidationError.assetNotFound(name: "Telegram")
        }

        guard UIImage(named: "Cloud") != nil else {
            throw ValidationError.assetNotFound(name: "Cloud")
        }

        guard UIImage(named: "Phone") != nil else {
            throw ValidationError.assetNotFound(name: "Phone")
        }

        guard UIImage(named: "Share") != nil else {
            throw ValidationError.assetNotFound(name: "Share")
        }

        guard UIImage(named: "Star") != nil else {
            throw ValidationError.assetNotFound(name: "Star")
        }

        guard UIImage(named: "Geo") != nil else {
            throw ValidationError.assetNotFound(name: "Geo")
        }

        print("All images are valid")
    }
}
