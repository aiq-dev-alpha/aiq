import Foundation
import Combine

// MARK: - Home View Model

@MainActor
final class HomeViewModel: BaseViewModel {
    // MARK: - Published Properties

    @Published var users: [User] = []
    @Published var searchText = ""
    @Published var filteredUsers: [User] = []

    // MARK: - Services

    private let networkingService: NetworkingServiceProtocol
    private let persistenceService: PersistenceServiceProtocol

    // MARK: - Initialization

    init(
        networkingService: NetworkingServiceProtocol = NetworkingService.shared,
        persistenceService: PersistenceServiceProtocol = PersistenceService.shared
    ) {
        self.networkingService = networkingService
        self.persistenceService = persistenceService
        super.init()
        setupSearchBinding()
        loadInitialData()
    }

    // MARK: - Public Methods

    func refreshData() async {
        await performTask {
            try await self.fetchUsers()
        }
    }

    func loadUser(_ user: User) async {
        await performTask {
            try await self.fetchUserDetails(user.id)
        }
    }

    // MARK: - Private Methods

    private func setupSearchBinding() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] searchText in
                self?.filterUsers(searchText)
            }
            .store(in: &cancellables)
    }

    private func loadInitialData() {
        Task {
            // Load cached data first
            loadCachedUsers()
            // Then fetch fresh data
            await refreshData()
        }
    }

    private func loadCachedUsers() {
        do {
            let cachedUsers = try persistenceService.fetchUsers()
            users = cachedUsers
            filterUsers(searchText)
        } catch {
            handleError(AppError.persistenceError(.fetchFailure))
        }
    }

    private func fetchUsers() async throws {
        let fetchedUsers = try await networkingService.fetchUsers()
        users = fetchedUsers
        filterUsers(searchText)

        // Cache the fetched users
        try persistenceService.saveUsers(fetchedUsers)
    }

    private func fetchUserDetails(_ userId: UUID) async throws -> User {
        return try await networkingService.fetchUser(id: userId)
    }

    private func filterUsers(_ searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { user in
                user.name.localizedCaseInsensitiveContains(searchText) ||
                user.email.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

// MARK: - Mock Data

extension HomeViewModel {
    static let mock: HomeViewModel = {
        let viewModel = HomeViewModel()
        viewModel.users = [
            User.mock,
            User(name: "Jane Smith", email: "jane.smith@example.com"),
            User(name: "Bob Johnson", email: "bob.johnson@example.com")
        ]
        viewModel.filteredUsers = viewModel.users
        return viewModel
    }()
}