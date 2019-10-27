import Foundation

public struct HTTPError: Error, CustomStringConvertible {

    // MARK: - Nested Types

    public enum Code {
        case unknown
        case cancelled
        case fileSystem
        case tooManyRequests
        case networkConnection
        case secureConnection
        case timedOut
        case badRequest
        case badResponse
        case resource
        case server
        case access
    }

    // MARK: - Instance Properties

    public let code: Code
    public let reason: Any?
    public let data: Data?

    public var statusCode: HTTPStatusCode? {
        reason as? HTTPStatusCode
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        var description = "\(String(describing: type(of: self))).\(code)"

        if let reason = reason {
            let reasonDescription: String

            if let reason = reason as? HTTPErrorStringConvertible {
                reasonDescription = reason.httpErrorDescription
            } else {
                reasonDescription = String(reflecting: reason)
            }

            description.append("(\(reasonDescription))")
        }

        return description
    }

    // MARK: - Initializers

    public init(code: Code, reason: Any? = nil, data: Data? = nil) {
        self.code = code
        self.reason = reason
        self.data = data
    }

    public init(urlError error: URLError, data: Data? = nil) {
        // swiftlint:disable:previous function_body_length

        let code: Code

        switch error.code {
        case .cancelled:
            code = .cancelled

        case .fileDoesNotExist,
             .fileIsDirectory,
             .cannotCreateFile,
             .cannotOpenFile,
             .cannotCloseFile,
             .cannotWriteToFile,
             .cannotRemoveFile,
             .cannotMoveFile:
            code = .fileSystem

        case .backgroundSessionInUseByAnotherProcess,
             .backgroundSessionRequiresSharedContainer,
             .backgroundSessionWasDisconnected,
             .cannotLoadFromNetwork,
             .cannotFindHost,
             .cannotConnectToHost,
             .dnsLookupFailed,
             .internationalRoamingOff,
             .networkConnectionLost,
             .notConnectedToInternet,
             .secureConnectionFailed,
             .callIsActive,
             .dataNotAllowed:
            code = .networkConnection

        case .clientCertificateRejected,
             .clientCertificateRequired,
             .serverCertificateHasBadDate,
             .serverCertificateHasUnknownRoot,
             .serverCertificateNotYetValid,
             .serverCertificateUntrusted:
            code = .secureConnection

        case .timedOut:
            code = .timedOut

        case .badURL,
             .requestBodyStreamExhausted,
             .unsupportedURL:
            code = .badRequest

        case .badServerResponse,
             .cannotDecodeContentData,
             .cannotDecodeRawData,
             .cannotParseResponse,
             .downloadDecodingFailedMidStream,
             .downloadDecodingFailedToComplete:
            code = .badResponse

        case .dataLengthExceedsMaximum,
             .httpTooManyRedirects,
             .redirectToNonExistentLocation,
             .resourceUnavailable,
             .zeroByteResource:
            code = .resource

        case .noPermissionsToReadFile,
             .userAuthenticationRequired,
             .userCancelledAuthentication:
            code = .access

        default:
            var availableCode: Code?

            if #available(macOS 10.11, iOS 9.0, watchOS 2.0, tvOS 9.0, *) {
                if error.code == .appTransportSecurityRequiresSecureConnection {
                    availableCode = .secureConnection
                }
            }

            code = availableCode ?? .unknown
        }

        self.init(code: code, reason: error, data: data)
    }

    public init?(statusCode: HTTPStatusCode, data: Data? = nil) {
        guard statusCode.state != .success else {
            return nil
        }

        let code: Code

        switch statusCode {
        case 429:
            code = .tooManyRequests

        case 511:
            code = .networkConnection

        case 408, 504:
            code = .timedOut

        case 400, 406, 411, 412, 413, 414, 415, 416, 417, 422, 424, 425, 426, 428, 431, 449:
            code = .badRequest

        case 404, 405, 409, 410, 423, 434, 451:
            code = .resource

        case 500, 501, 502, 503, 505, 506, 507, 508, 509, 510:
            code = .server

        case 401, 402, 403, 407, 444:
            code = .access

        default:
            code = .unknown
        }

        self.init(code: code, reason: statusCode, data: data)
    }
}
