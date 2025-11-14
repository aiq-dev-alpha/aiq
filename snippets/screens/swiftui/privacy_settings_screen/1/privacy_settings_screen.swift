import SwiftUI

struct PrivacySettingsScreen: View {
    @State private var publicProfile = true
    @State private var showEmail = false
    @State private var showPhone = false
    @State private var showLastSeen = true
    @State private var whoCanMessage = "Everyone"
    @State private var whoCanFollow = "Everyone"
    @State private var personalizedAds = true
    @State private var analyticsData = true
    @State private var crashReports = true
    @State private var locationData = false

    var body: some View {
        List {
            Section("Profile Privacy") {
                Toggle("Public Profile", isOn: $publicProfile)
                Toggle("Show Email Address", isOn: $showEmail)
                Toggle("Show Phone Number", isOn: $showPhone)
                Toggle("Show Last Seen", isOn: $showLastSeen)
            }

            Section("Contact Permissions") {
                Picker("Who can message you", selection: $whoCanMessage) {
                    Text("Everyone").tag("Everyone")
                    Text("Friends only").tag("Friends only")
                    Text("No one").tag("No one")
                }

                Picker("Who can follow you", selection: $whoCanFollow) {
                    Text("Everyone").tag("Everyone")
                    Text("Friends of friends").tag("Friends of friends")
                    Text("No one").tag("No one")
                }
            }

            Section("Data Collection & Usage") {
                Toggle("Personalized Ads", isOn: $personalizedAds)
                Toggle("Analytics Data", isOn: $analyticsData)
                Toggle("Crash Reports", isOn: $crashReports)
                Toggle("Location Data", isOn: $locationData)
            }

            Section("Advanced Privacy") {
                NavigationLink("Blocked Users", destination: BlockedUsersView())
                NavigationLink("Content Filtering", destination: ContentFilteringView())
                NavigationLink("Data Download", destination: DataDownloadView())
                Button("Clear Data") {
                    // Clear data
                }
            }
        }
        .navigationTitle("Privacy Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct BlockedUsersView: View {
    var body: some View {
        List {
            Text("No blocked users")
                .foregroundColor(.secondary)
        }
        .navigationTitle("Blocked Users")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ContentFilteringView: View {
    var body: some View {
        List {
            Toggle("Hide explicit content", isOn: .constant(true))
            Toggle("Filter profanity", isOn: .constant(false))
            Toggle("Hide sensitive topics", isOn: .constant(false))
        }
        .navigationTitle("Content Filtering")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DataDownloadView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Download Your Data")
                .font(.headline)

            Text("We will prepare a copy of your data and send a download link to your email address. This may take up to 24 hours.")
                .multilineTextAlignment(.center)
                .padding()

            Button("Request Download") {
                // Request data download
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
        .navigationTitle("Data Download")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        PrivacySettingsScreen()
    }
}