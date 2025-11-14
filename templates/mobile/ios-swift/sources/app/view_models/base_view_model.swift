import Foundation
import Combine

// MARK: - Base View Model

@MainActor
class BaseViewModel: ObservableObject {
    // MARK: - Properties

    @Published var isLoading = false
    @Published var error: AppError?
    @Published var showingError = false

    // Combine
    protected var cancellables = Set<AnyCancellable>()

    // MARK: - Error Handling

    func handleError(_ error: Error) {
        if let appError = error as? AppError {
            self.error = appError
        } else if let networkError = error as? NetworkError {
            self.error = .networkError(networkError)
        } else if let persistenceError = error as? PersistenceError {
            self.error = .persistenceError(persistenceError)
        } else {
            self.error = .unknown(error.localizedDescription)
        }
        showingError = true
    }

    func clearError() {
        error = nil
        showingError = false
    }

    // MARK: - Loading State

    func setLoading(_ loading: Bool) {
        isLoading = loading
    }

    // MARK: - Async Task Helper

    func performTask<T>(_ task: @escaping () async throws -> T) async -> T? {
        setLoading(true)
        defer { setLoading(false) }

        do {
            return try await task()
        } catch {
            handleError(error)
            return nil
        }
    }

    // MARK: - Combine Task Helper

    func performPublisherTask<T: Publisher>(
        _ publisher: T,
        receiveValue: @escaping (T.Output) -> Void = { _ in }
    ) where T.Failure == Error {
        setLoading(true)

        publisher
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.setLoading(false)
                    if case .failure(let error) = completion {
                        self?.handleError(error)
                    }
                },
                receiveValue: receiveValue
            )
            .store(in: &cancellables)
    }

    // MARK: - Deinitializer

    deinit {
        cancellables.removeAll()
    }
}