import SwiftUI

struct SettingsView: View {
    // MARK: - Properties

    @StateObject private var viewModel = SettingsViewModel()
    @EnvironmentObject private var appState: AppState

    // MARK: - Body

    var body: some View {
        NavigationView {
            List {
                // MARK: - Appearance Section
                Section("Appearance") {
                    AppearanceSettingsView(viewModel: viewModel)
                }

                // MARK: - Notifications Section
                Section("Notifications") {
                    NotificationSettingsView(viewModel: viewModel)
                }

                // MARK: - Privacy Section
                Section("Privacy & Security") {
                    PrivacySettingsView(viewModel: viewModel)
                }

                // MARK: - Data Section
                Section("Data Management") {
                    DataSettingsView(viewModel: viewModel)
                }

                // MARK: - Support Section
                Section("Support") {
                    SupportSettingsView()
                }

                // MARK: - About Section
                Section("About") {
                    AboutSettingsView()
                }
            }
            .navigationTitle("Settings")
            .alert("Error", isPresented: $viewModel.showingError) {
                Button("OK") {
                    viewModel.clearError()
                }
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Unknown error")
            }
        }
    }
}

// MARK: - Appearance Settings

struct AppearanceSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        HStack {
            Image(systemName: "paintbrush")
                .foregroundColor(.blue)
                .frame(width: 24)

            VStack(alignment: .leading) {
                Text("Theme")
                    .font(.body)

                Text(viewModel.selectedTheme.rawValue.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Picker("Theme", selection: $viewModel.selectedTheme) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Text(theme.rawValue.capitalized).tag(theme)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Notification Settings

struct NotificationSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Group {
            HStack {
                Image(systemName: "bell")
                    .foregroundColor(.orange)
                    .frame(width: 24)

                Text("Push Notifications")

                Spacer()

                Toggle("", isOn: $viewModel.pushNotificationsEnabled)
            }

            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.green)
                    .frame(width: 24)

                Text("Email Notifications")

                Spacer()

                Toggle("", isOn: $viewModel.emailNotificationsEnabled)
            }
        }
    }
}

// MARK: - Privacy Settings

struct PrivacySettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Group {
            HStack {
                Image(systemName: "lock.shield")
                    .foregroundColor(.red)
                    .frame(width: 24)

                Text("Face ID / Touch ID")

                Spacer()

                Toggle("", isOn: $viewModel.biometricEnabled)
            }

            NavigationLink(destination: PrivacyPolicyView()) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.purple)
                        .frame(width: 24)

                    Text("Privacy Policy")
                }
            }

            NavigationLink(destination: DataUsageView()) {
                HStack {
                    Image(systemName: "chart.bar")
                        .foregroundColor(.blue)
                        .frame(width: 24)

                    Text("Data Usage")
                }
            }
        }
    }
}

// MARK: - Data Settings

struct DataSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        Group {
            Button(action: {
                Task {
                    await viewModel.clearCache()
                }
            }) {
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(.orange)
                        .frame(width: 24)

                    Text("Clear Cache")
                        .foregroundColor(.primary)

                    Spacer()

                    if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(0.8)
                    }
                }
            }
            .disabled(viewModel.isLoading)

            Button(action: {
                viewModel.showingDeleteDataAlert = true
            }) {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.red)
                        .frame(width: 24)

                    Text("Delete All Data")
                        .foregroundColor(.red)
                }
            }
            .alert("Delete All Data", isPresented: $viewModel.showingDeleteDataAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    Task {
                        await viewModel.deleteAllData()
                    }
                }
            } message: {
                Text("This action cannot be undone. All your data will be permanently deleted.")
            }
        }
    }
}

// MARK: - Support Settings

struct SupportSettingsView: View {
    var body: some View {
        Group {
            NavigationLink(destination: HelpView()) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.blue)
                        .frame(width: 24)

                    Text("Help & FAQ")
                }
            }

            Button(action: {
                // Open contact support
                if let url = URL(string: "mailto:support@yourapp.com") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.green)
                        .frame(width: 24)

                    Text("Contact Support")
                        .foregroundColor(.primary)
                }
            }

            Button(action: {
                // Share feedback
                shareApp()
            }) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.purple)
                        .frame(width: 24)

                    Text("Share App")
                        .foregroundColor(.primary)
                }
            }
        }
    }

    private func shareApp() {
        let activityVC = UIActivityViewController(
            activityItems: ["Check out this amazing app!"],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
}

// MARK: - About Settings

struct AboutSettingsView: View {
    var body: some View {
        Group {
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .frame(width: 24)

                VStack(alignment: .leading) {
                    Text("Version")
                        .font(.body)

                    Text("1.0.0 (Build 1)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            NavigationLink(destination: LicensesView()) {
                HStack {
                    Image(systemName: "doc.text")
                        .foregroundColor(.green)
                        .frame(width: 24)

                    Text("Open Source Licenses")
                }
            }

            NavigationLink(destination: TermsOfServiceView()) {
                HStack {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(.orange)
                        .frame(width: 24)

                    Text("Terms of Service")
                }
            }
        }
    }
}

// MARK: - Supporting Views

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("Privacy Policy content would go here...")
                .padding()
        }
        .navigationTitle("Privacy Policy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataUsageView: View {
    var body: some View {
        List {
            Text("Data usage statistics would go here...")
        }
        .navigationTitle("Data Usage")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HelpView: View {
    var body: some View {
        List {
            Text("Help and FAQ content would go here...")
        }
        .navigationTitle("Help & FAQ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LicensesView: View {
    var body: some View {
        ScrollView {
            Text("Open source licenses would go here...")
                .padding()
        }
        .navigationTitle("Licenses")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct TermsOfServiceView: View {
    var body: some View {
        ScrollView {
            Text("Terms of service content would go here...")
                .padding()
        }
        .navigationTitle("Terms of Service")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Settings View Model

@MainActor
final class SettingsViewModel: BaseViewModel {
    // MARK: - Published Properties

    @Published var selectedTheme: AppTheme = .system
    @Published var pushNotificationsEnabled = true
    @Published var emailNotificationsEnabled = true
    @Published var biometricEnabled = false
    @Published var showingDeleteDataAlert = false

    // MARK: - Services

    private let persistenceService: PersistenceServiceProtocol

    // MARK: - Initialization

    init(persistenceService: PersistenceServiceProtocol = PersistenceService.shared) {
        self.persistenceService = persistenceService
        super.init()
        loadSettings()
    }

    // MARK: - Public Methods

    func clearCache() async {
        await performTask {
            // Implement cache clearing logic
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate work
            print("Cache cleared successfully")
        }
    }

    func deleteAllData() async {
        await performTask {
            // Implement data deletion logic
            try await Task.sleep(nanoseconds: 1_000_000_000) // Simulate work
            print("All data deleted successfully")
        }
    }

    // MARK: - Private Methods

    private func loadSettings() {
        // Load settings from UserDefaults or other persistence
        selectedTheme = AppTheme(rawValue: UserDefaults.standard.string(forKey: "selectedTheme") ?? "system") ?? .system
        pushNotificationsEnabled = UserDefaults.standard.bool(forKey: "pushNotificationsEnabled")
        emailNotificationsEnabled = UserDefaults.standard.bool(forKey: "emailNotificationsEnabled")
        biometricEnabled = UserDefaults.standard.bool(forKey: "biometricEnabled")
    }

    private func saveSettings() {
        UserDefaults.standard.set(selectedTheme.rawValue, forKey: "selectedTheme")
        UserDefaults.standard.set(pushNotificationsEnabled, forKey: "pushNotificationsEnabled")
        UserDefaults.standard.set(emailNotificationsEnabled, forKey: "emailNotificationsEnabled")
        UserDefaults.standard.set(biometricEnabled, forKey: "biometricEnabled")
    }
}

// MARK: - App Theme

enum AppTheme: String, CaseIterable {
    case light = "light"
    case dark = "dark"
    case system = "system"
}

// MARK: - Preview

#Preview {
    SettingsView()
        .environmentObject(AppState())
}