import Foundation

public enum AssetIdiom: Hashable {

    // MARK: - Enumeration Cases

    case universal
    case iPhone
    case iPad(subtype: AssetIdiomIPadSubtype?)
    case mac
    case watch
    case tv
    case car
}
