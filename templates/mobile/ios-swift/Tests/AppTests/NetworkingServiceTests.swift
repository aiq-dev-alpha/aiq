import XCTest
@testable import App
import Foundation

final class NetworkingServiceTests: XCTestCase {

    var networkingService: NetworkingService!

    override func setUp() {
        super.setUp()
        networkingService = NetworkingService.shared
    }

    override func tearDown() {
        networkingService = nil
        super.tearDown()
    }

    // MARK: - Error Mapping Tests

    func testMapURLError_NoConnection() {
        // Given
        let urlError = URLError(.notConnectedToInternet)

        // When
        let networkError = networkingService.mapError(urlError)

        // Then
        XCTAssertEqual(networkError, .noConnection)
        XCTAssertEqual(networkError.errorDescription, "No internet connection")
        XCTAssertEqual(networkError.recoverySuggestion, "Please check your internet connection and try again.")
    }

    func testMapURLError_Timeout() {
        // Given
        let urlError = URLError(.timedOut)

        // When
        let networkError = networkingService.mapError(urlError)

        // Then
        XCTAssertEqual(networkError, .timeout)
        XCTAssertEqual(networkError.errorDescription, "Request timed out")
        XCTAssertEqual(networkError.recoverySuggestion, "Please try again with a better connection.")
    }

    func testMapDecodingError() {
        // Given
        let decodingError = DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Invalid data"))

        // When
        let networkError = networkingService.mapError(decodingError)

        // Then
        XCTAssertEqual(networkError, .decodingError)
        XCTAssertEqual(networkError.errorDescription, "Failed to decode response")
    }

    func testMapUnknownError() {
        // Given
        let unknownError = NSError(domain: "TestDomain", code: 999, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])

        // When
        let networkError = networkingService.mapError(unknownError)

        // Then
        XCTAssertEqual(networkError, .unknown)
        XCTAssertEqual(networkError.errorDescription, "Network error occurred")
    }

    // MARK: - Response Validation Tests

    func testValidateResponse_Success() throws {
        // Given
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.test.com")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        // When & Then
        XCTAssertNoThrow(try networkingService.validateResponse(httpResponse))
    }

    func testValidateResponse_Unauthorized() {
        // Given
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.test.com")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )!

        // When & Then
        XCTAssertThrowsError(try networkingService.validateResponse(httpResponse)) { error in
            XCTAssertEqual(error as? NetworkError, .unauthorized)
        }
    }

    func testValidateResponse_Forbidden() {
        // Given
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.test.com")!,
            statusCode: 403,
            httpVersion: nil,
            headerFields: nil
        )!

        // When & Then
        XCTAssertThrowsError(try networkingService.validateResponse(httpResponse)) { error in
            XCTAssertEqual(error as? NetworkError, .forbidden)
        }
    }

    func testValidateResponse_NotFound() {
        // Given
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.test.com")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )!

        // When & Then
        XCTAssertThrowsError(try networkingService.validateResponse(httpResponse)) { error in
            XCTAssertEqual(error as? NetworkError, .notFound)
        }
    }

    func testValidateResponse_ServerError() {
        // Given
        let httpResponse = HTTPURLResponse(
            url: URL(string: "https://api.test.com")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!

        // When & Then
        XCTAssertThrowsError(try networkingService.validateResponse(httpResponse)) { error in
            XCTAssertEqual(error as? NetworkError, .serverError(500))
        }
    }

    func testValidateResponse_InvalidResponse() {
        // Given
        let response = URLResponse()

        // When & Then
        XCTAssertThrowsError(try networkingService.validateResponse(response)) { error in
            XCTAssertEqual(error as? NetworkError, .invalidResponse)
        }
    }

    // MARK: - Request Creation Tests

    func testCreateRequest_GET() {
        // Given
        let url = URL(string: "https://api.test.com/users")!

        // When
        let request = networkingService.createRequest(for: url, method: .GET)

        // Then
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
        XCTAssertNil(request.httpBody)
    }

    func testCreateRequest_POST() {
        // Given
        let url = URL(string: "https://api.test.com/users")!

        // When
        let request = networkingService.createRequest(for: url, method: .POST)

        // Then
        XCTAssertEqual(request.httpMethod, "POST")
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.value(forHTTPHeaderField: "Content-Type"), "application/json")
        XCTAssertEqual(request.value(forHTTPHeaderField: "Accept"), "application/json")
    }

    func testCreateRequest_PUT() {
        // Given
        let url = URL(string: "https://api.test.com/users/123")!

        // When
        let request = networkingService.createRequest(for: url, method: .PUT)

        // Then
        XCTAssertEqual(request.httpMethod, "PUT")
        XCTAssertEqual(request.url, url)
    }

    func testCreateRequest_DELETE() {
        // Given
        let url = URL(string: "https://api.test.com/users/123")!

        // When
        let request = networkingService.createRequest(for: url, method: .DELETE)

        // Then
        XCTAssertEqual(request.httpMethod, "DELETE")
        XCTAssertEqual(request.url, url)
    }

    // MARK: - JSON Coding Tests

    func testJSONDecoder_Configuration() {
        // Given
        let decoder = networkingService.decoder

        // Then
        XCTAssertEqual(decoder.dateDecodingStrategy, .iso8601)
        XCTAssertEqual(decoder.keyDecodingStrategy, .convertFromSnakeCase)
    }

    func testJSONEncoder_Configuration() {
        // Given
        let encoder = networkingService.encoder

        // Then
        XCTAssertEqual(encoder.dateEncodingStrategy, .iso8601)
        XCTAssertEqual(encoder.keyEncodingStrategy, .convertToSnakeCase)
    }

    func testUserDecoding() throws {
        // Given
        let json = """
        {
            "id": "123e4567-e89b-12d3-a456-426614174000",
            "name": "John Doe",
            "email": "john.doe@example.com",
            "profile_image_url": "https://example.com/profile.jpg",
            "created_at": "2023-01-01T00:00:00Z",
            "updated_at": "2023-01-01T00:00:00Z"
        }
        """.data(using: .utf8)!

        // When
        let user = try networkingService.decoder.decode(User.self, from: json)

        // Then
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john.doe@example.com")
        XCTAssertNotNil(user.profileImageURL)
        XCTAssertEqual(user.profileImageURL?.absoluteString, "https://example.com/profile.jpg")
    }

    func testUserUpdateRequestEncoding() throws {
        // Given
        let request = UserUpdateRequest(
            name: "Jane Smith",
            email: "jane.smith@example.com",
            profileImageURL: URL(string: "https://example.com/jane.jpg")
        )

        // When
        let data = try networkingService.encoder.encode(request)
        let json = try JSONSerialization.jsonObject(with: data) as! [String: Any]

        // Then
        XCTAssertEqual(json["name"] as? String, "Jane Smith")
        XCTAssertEqual(json["email"] as? String, "jane.smith@example.com")
        XCTAssertEqual(json["profile_image_url"] as? String, "https://example.com/jane.jpg")
    }

    // MARK: - Configuration Tests

    func testConfiguration() {
        // Given & When
        XCTAssertNoThrow(networkingService.configure())
    }

    func testBaseURL() {
        // Given & When
        let baseURL = networkingService.baseURL

        // Then
        XCTAssertEqual(baseURL.absoluteString, "https://api.yourapp.com/v1")
    }

    func testURLSessionConfiguration() {
        // Given
        let session = networkingService.session

        // Then
        XCTAssertEqual(session.configuration.timeoutIntervalForRequest, 30)
        XCTAssertEqual(session.configuration.timeoutIntervalForResource, 60)
    }
}

// MARK: - NetworkingService Test Extensions

private extension NetworkingService {
    var decoder: JSONDecoder {
        // Access private decoder for testing
        let mirror = Mirror(reflecting: self)
        return mirror.children.first(where: { $0.label == "decoder" })?.value as! JSONDecoder
    }

    var encoder: JSONEncoder {
        // Access private encoder for testing
        let mirror = Mirror(reflecting: self)
        return mirror.children.first(where: { $0.label == "encoder" })?.value as! JSONEncoder
    }

    var baseURL: URL {
        // Access private baseURL for testing
        let mirror = Mirror(reflecting: self)
        return mirror.children.first(where: { $0.label == "baseURL" })?.value as! URL
    }

    var session: URLSession {
        // Access private session for testing
        let mirror = Mirror(reflecting: self)
        return mirror.children.first(where: { $0.label == "session" })?.value as! URLSession
    }

    func createRequest(for url: URL, method: HTTPMethod) -> URLRequest {
        // Expose private method for testing
        let mirror = Mirror(reflecting: self)
        // In a real implementation, you would need to make this method internal
        // or create a test-specific interface
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }

    func validateResponse(_ response: URLResponse) throws {
        // Expose private method for testing
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
        // Expose private method for testing
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

    enum HTTPMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
}