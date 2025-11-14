import Foundation
import Combine

// MARK: - Networking Service Protocol

protocol NetworkingServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(id: UUID) async throws -> User
    func updateUser(_ user: User, with request: UserUpdateRequest) async throws -> User
    func deleteUser(id: UUID) async throws
}

// MARK: - Networking Service

final class NetworkingService: NetworkingServiceProtocol {
    // MARK: - Singleton

    static let shared = NetworkingService()

    // MARK: - Properties

    private let session: URLSession
    private let baseURL: URL
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    // MARK: - Initialization

    private init() {
        // Configure URL session
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: config)

        // Set base URL (replace with your API base URL)
        self.baseURL = URL(string: "https://api.yourapp.com/v1")!

        // Configure JSON decoder
        self.decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        // Configure JSON encoder
        self.encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.keyEncodingStrategy = .convertToSnakeCase
    }

    // MARK: - Configuration

    func configure() {
        // Add any initial configuration here
        print("NetworkingService configured successfully")
    }

    // MARK: - Public Methods

    func fetchUsers() async throws -> [User] {
        let endpoint = baseURL.appendingPathComponent("users")
        let request = createRequest(for: endpoint, method: .GET)

        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            return try decoder.decode([User].self, from: data)
        } catch {
            throw mapError(error)
        }
    }

    func fetchUser(id: UUID) async throws -> User {
        let endpoint = baseURL.appendingPathComponent("users/\(id)")
        let request = createRequest(for: endpoint, method: .GET)

        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            return try decoder.decode(User.self, from: data)
        } catch {
            throw mapError(error)
        }
    }

    func updateUser(_ user: User, with request: UserUpdateRequest) async throws -> User {
        let endpoint = baseURL.appendingPathComponent("users/\(user.id)")
        var urlRequest = createRequest(for: endpoint, method: .PUT)

        do {
            let requestBody = try encoder.encode(request)
            urlRequest.httpBody = requestBody

            let (data, response) = try await session.data(for: urlRequest)
            try validateResponse(response)
            return try decoder.decode(User.self, from: data)
        } catch {
            throw mapError(error)
        }
    }

    func deleteUser(id: UUID) async throws {
        let endpoint = baseURL.appendingPathComponent("users/\(id)")
        let request = createRequest(for: endpoint, method: .DELETE)

        do {
            let (_, response) = try await session.data(for: request)
            try validateResponse(response)
        } catch {
            throw mapError(error)
        }
    }
}

// MARK: - Private Methods

private extension NetworkingService {
    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }

    func createRequest(for url: URL, method: HTTPMethod) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // Add authentication header if needed
        // request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        return request
    }

    func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        switch httpResponse.statusCode {
        case 200...299:
            break
        case 401:
            throw NetworkError.unauthorized
        case 403:
            throw NetworkError.forbidden
        case 404:
            throw NetworkError.notFound
        case 500...599:
            throw NetworkError.serverError(httpResponse.statusCode)
        default:
            throw NetworkError.unknown
        }
    }

    func mapError(_ error: Error) -> NetworkError {
        if let networkError = error as? NetworkError {
            return networkError
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet, .networkConnectionLost:
                return .noConnection
            case .timedOut:
                return .timeout
            default:
                return .unknown
            }
        }

        if error is DecodingError {
            return .decodingError
        }

        return .unknown
    }
}

// MARK: - Mock Implementation

#if DEBUG
final class MockNetworkingService: NetworkingServiceProtocol {
    func fetchUsers() async throws -> [User] {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return [
            User.mock,
            User(name: "Jane Smith", email: "jane.smith@example.com"),
            User(name: "Bob Johnson", email: "bob.johnson@example.com")
        ]
    }

    func fetchUser(id: UUID) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        return User.mock
    }

    func updateUser(_ user: User, with request: UserUpdateRequest) async throws -> User {
        try await Task.sleep(nanoseconds: 500_000_000)
        var updatedUser = user
        // Apply updates (this is simplified)
        return updatedUser
    }

    func deleteUser(id: UUID) async throws {
        try await Task.sleep(nanoseconds: 500_000_000)
    }
}
#endif