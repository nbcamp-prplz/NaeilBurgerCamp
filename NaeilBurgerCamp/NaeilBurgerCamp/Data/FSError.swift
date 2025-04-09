import Foundation

enum FSError: Error {
    case invalidURL
    case httpError(statusCode: Int)
    case noData
    case decodingFailed(message: String)
    case unknownError(message: String)
}
