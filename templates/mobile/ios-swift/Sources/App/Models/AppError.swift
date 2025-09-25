import Foundation

// MARK: - App Error

enum AppError: LocalizedError, Equatable {
    case networkError(NetworkError)
    case persistenceError(PersistenceError)
    case validationError(String)
    case unknown(String)

    var errorDescription: String? {
        switch self {
        case .networkError(let error):
            return error.errorDescription
        case .persistenceError(let error):
            return error.errorDescription
        case .validationError(let message):
            return "Validation Error: \(message)"
        case .unknown(let message):
            return "Unknown Error: \(message)"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .networkError(let error):
            return error.recoverySuggestion
        case .persistenceError(let error):
            return error.recoverySuggestion
        case .validationError:
            return "Please check your input and try again."
        case .unknown:
            return "Please try again or contact support if the problem persists."
        }
    }
}

// MARK: - Network Error

enum NetworkError: LocalizedError, Equatable {
    case noConnection
    case timeout
    case serverError(Int)
    case invalidResponse
    case decodingError
    case unauthorized
    case forbidden
    case notFound
    case unknown

    var errorDescription: String? {
        switch self {
        case .noConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .serverError(let code):
            return "Server error (\(code))"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized access"
        case .forbidden:
            return "Access forbidden"
        case .notFound:
            return "Resource not found"
        case .unknown:
            return "Network error occurred"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .noConnection:
            return "Please check your internet connection and try again."
        case .timeout:
            return "Please try again with a better connection."
        case .serverError:
            return "Please try again later."
        case .invalidResponse, .decodingError:
            return "Please update the app or try again later."
        case .unauthorized:
            return "Please log in again."
        case .forbidden:
            return "You don't have permission to access this resource."
        case .notFound:
            return "The requested resource could not be found."
        case .unknown:
            return "Please try again or contact support."
        }
    }
}

// MARK: - Persistence Error

enum PersistenceError: LocalizedError, Equatable {
    case saveFailure
    case fetchFailure
    case deleteFailure
    case coreDataUnavailable
    case unknown

    var errorDescription: String? {
        switch self {
        case .saveFailure:
            return "Failed to save data"
        case .fetchFailure:
            return "Failed to fetch data"
        case .deleteFailure:
            return "Failed to delete data"
        case .coreDataUnavailable:
            return "Data storage unavailable"
        case .unknown:
            return "Data storage error occurred"
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .saveFailure, .fetchFailure, .deleteFailure:
            return "Please try again or restart the app."
        case .coreDataUnavailable:
            return "Please restart the app."
        case .unknown:
            return "Please try again or contact support."
        }
    }
}