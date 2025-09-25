import SwiftUI
import Combine

@main
struct iOSApp: App {
    // MARK: - Properties

    @StateObject private var appState = AppState()

    // Core Data stack
    let persistenceController = PersistenceController.shared

    // MARK: - Body

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(appState)
                .onAppear {
                    setupApp()
                }
        }
    }

    // MARK: - Private Methods

    private func setupApp() {
        // Configure appearance
        configureAppearance()

        // Initialize services
        NetworkingService.shared.configure()

        print("App initialized successfully")
    }

    private func configureAppearance() {
        // Configure navigation bar appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemBackground
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.label]

        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance

        // Configure tab bar appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}

// MARK: - App State

class AppState: ObservableObject {
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var selectedTab = 0

    func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }

    func clearError() {
        showingError = false
        errorMessage = ""
    }
}