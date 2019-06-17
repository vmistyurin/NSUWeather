import Foundation

enum WeatherServiceError: Error {
    case emptyResponse
    case incorrectResponse
}

// MARK: - LocalizedError implementation

extension WeatherServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyResponse:
            return "Server returned empty response"
        case .incorrectResponse:
            return "Response couldn't be parsed"
        }
    }
}
