import XCTest
@testable import App

@MainActor
final class HomeViewModelTests: XCTestCase {

    var mockNetworkingService: MockNetworkingService!
    var mockPersistenceService: MockPersistenceService!
    var viewModel: HomeViewModel!

    override func setUp() {
        super.setUp()
        mockNetworkingService = MockNetworkingService()
        mockPersistenceService = MockPersistenceService()
        viewModel = HomeViewModel(
            networkingService: mockNetworkingService,
            persistenceService: mockPersistenceService
        )
    }

    override func tearDown() {
        viewModel = nil
        mockNetworkingService = nil
        mockPersistenceService = nil
        super.tearDown()
    }

    // MARK: - Tests

    func testInitialState() {
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
        XCTAssertTrue(viewModel.searchText.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

    func testRefreshData() async {
        // Given
        let expectedUsers = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]
        mockNetworkingService.mockUsers = expectedUsers

        // When
        await viewModel.refreshData()

        // Then
        XCTAssertEqual(viewModel.users.count, 2)
        XCTAssertEqual(viewModel.users[0].name, "John Doe")
        XCTAssertEqual(viewModel.users[1].name, "Jane Smith")
        XCTAssertEqual(viewModel.filteredUsers.count, 2)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testRefreshDataWithError() async {
        // Given
        mockNetworkingService.shouldThrowError = true

        // When
        await viewModel.refreshData()

        // Then
        XCTAssertTrue(viewModel.users.isEmpty)
        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
        XCTAssertNotNil(viewModel.error)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSearchFiltering() async {
        // Given
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com"),
            User(name: "Bob Johnson", email: "bob@example.com")
        ]
        mockNetworkingService.mockUsers = users
        await viewModel.refreshData()

        // When - Search by name
        viewModel.searchText = "John"

        // Small delay to allow debouncing
        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertEqual(viewModel.filteredUsers.count, 1)
        XCTAssertEqual(viewModel.filteredUsers[0].name, "John Doe")

        // When - Search by email
        viewModel.searchText = "jane@"

        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertEqual(viewModel.filteredUsers.count, 1)
        XCTAssertEqual(viewModel.filteredUsers[0].email, "jane@example.com")

        // When - Clear search
        viewModel.searchText = ""

        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertEqual(viewModel.filteredUsers.count, 3)
    }

    func testSearchWithNoResults() async {
        // Given
        let users = [
            User(name: "John Doe", email: "john@example.com"),
            User(name: "Jane Smith", email: "jane@example.com")
        ]
        mockNetworkingService.mockUsers = users
        await viewModel.refreshData()

        // When
        viewModel.searchText = "NonExistent"

        try? await Task.sleep(nanoseconds: 500_000_000)

        // Then
        XCTAssertTrue(viewModel.filteredUsers.isEmpty)
        XCTAssertEqual(viewModel.users.count, 2) // Original users should remain
    }

    func testLoadUser() async {
        // Given
        let user = User(name: "John Doe", email: "john@example.com")
        mockNetworkingService.mockUser = user

        // When
        await viewModel.loadUser(user)

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.error)
    }

    func testLoadUserWithError() async {
        // Given
        let user = User(name: "John Doe", email: "john@example.com")
        mockNetworkingService.shouldThrowError = true

        // When
        await viewModel.loadUser(user)

        // Then
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNotNil(viewModel.error)
    }

    func testCachedUsersLoading() {
        // Given
        let cachedUsers = [
            User(name: "Cached User", email: "cached@example.com")
        ]
        mockPersistenceService.mockUsers = cachedUsers

        // When
        let newViewModel = HomeViewModel(
            networkingService: mockNetworkingService,
            persistenceService: mockPersistenceService
        )

        // Then
        XCTAssertEqual(newViewModel.users.count, 1)
        XCTAssertEqual(newViewModel.users[0].name, "Cached User")
    }

    func testErrorHandling() async {
        // Given
        mockNetworkingService.shouldThrowError = true

        // When
        await viewModel.refreshData()

        // Then
        XCTAssertTrue(viewModel.showingError)
        XCTAssertNotNil(viewModel.error)

        // When - Clear error
        viewModel.clearError()

        // Then
        XCTAssertFalse(viewModel.showingError)
        XCTAssertNil(viewModel.error)
    }
}

// MARK: - Mock Services

final class MockNetworkingService: NetworkingServiceProtocol {
    var mockUsers: [User] = []
    var mockUser: User?
    var shouldThrowError = false

    func fetchUsers() async throws -> [User] {
        if shouldThrowError {
            throw NetworkError.serverError(500)
        }
        return mockUsers
    }

    func fetchUser(id: UUID) async throws -> User {
        if shouldThrowError {
            throw NetworkError.notFound
        }
        return mockUser ?? User(name: "Mock User", email: "mock@example.com")
    }

    func updateUser(_ user: User, with request: UserUpdateRequest) async throws -> User {
        if shouldThrowError {
            throw NetworkError.serverError(500)
        }
        return user
    }

    func deleteUser(id: UUID) async throws {
        if shouldThrowError {
            throw NetworkError.serverError(500)
        }
    }
}

final class MockPersistenceService: PersistenceServiceProtocol {
    var mockUsers: [User] = []
    var shouldThrowError = false

    func fetchUsers() throws -> [User] {
        if shouldThrowError {
            throw PersistenceError.fetchFailure
        }
        return mockUsers
    }

    func saveUsers(_ users: [User]) throws {
        if shouldThrowError {
            throw PersistenceError.saveFailure
        }
        mockUsers = users
    }

    func deleteUser(id: UUID) throws {
        if shouldThrowError {
            throw PersistenceError.deleteFailure
        }
        mockUsers.removeAll { $0.id == id }
    }

    func updateUser(_ user: User) throws {
        if shouldThrowError {
            throw PersistenceError.saveFailure
        }
        if let index = mockUsers.firstIndex(where: { $0.id == user.id }) {
            mockUsers[index] = user
        } else {
            mockUsers.append(user)
        }
    }
}