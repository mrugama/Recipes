import Foundation

enum NetworkError: LocalizedError {
    case invalidURL,
         invalidResponse,
         requestFailed(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid URL"
        case .invalidResponse: return "Invalid response"
        case .requestFailed(statusCode: let statusCode):
            return "Request failed with status code \(statusCode)"
        }
    }
}
