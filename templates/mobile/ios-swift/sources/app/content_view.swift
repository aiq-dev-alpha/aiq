import SwiftUI

struct ContentView: View {
    // MARK: - Properties

    @EnvironmentObject private var appState: AppState

    // MARK: - Body

    var body: some Scene {
        TabView(selection: $appState.selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(2)
        }
        .accentColor(.blue)
        .overlay(
            // Global loading indicator
            Group {
                if appState.isLoading {
                    LoadingView()
                }
            }
        )
        .alert("Error", isPresented: $appState.showingError) {
            Button("OK") {
                appState.clearError()
            }
        } message: {
            Text(appState.errorMessage)
        }
    }
}

// MARK: - Loading View

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.2)

                Text("Loading...")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.regularMaterial)
            )
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
        .environmentObject(AppState())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}