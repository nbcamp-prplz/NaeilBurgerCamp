import Foundation

enum FSError: LocalizedError {
    case invalidURL(urlString: String)
    case httpError(statusCode: Int)
    case noData
    case encodingFailed(message: String)
    case decodingFailed(message: String)
    case unknownError(message: String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "invalidURL: \(urlString)"
        case .httpError(let statusCode):
            return "HTTPError: \(statusCode)"
        case .noData:
            return "NoData"
        case .encodingFailed(let message):
            return "EncodingFailed: \(message)"
        case .decodingFailed(let message):
            return "DecodingFailed: \(message)"
        case .unknownError(let message):
            return "UnknownError: \(message)"
        }
    }
}
