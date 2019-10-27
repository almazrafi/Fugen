import Foundation

internal enum URLEncodedFormComponent {

    // MARK: - Enumeration Cases

    case string(String)
    case array([URLEncodedFormComponent])
    case dictionary([String: URLEncodedFormComponent])

    // MARK: - Instance Properties

    internal var array: [URLEncodedFormComponent]? {
        switch self {
        case let .array(array):
            return array

        default:
            return nil
        }
    }

    internal var dictionary: [String: URLEncodedFormComponent]? {
        switch self {
        case let .dictionary(object):
            return object

        default:
            return nil
        }
    }
}
