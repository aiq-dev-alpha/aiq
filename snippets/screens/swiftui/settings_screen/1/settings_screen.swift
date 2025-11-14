import SwiftUI

struct SettingsScreen: View {
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationView {
            List {
                // Account Section
                Section("Account") {
                    NavigationLink(destination: ProfileScreen()) {
                        SettingsRow(
                            icon: "person.circle",
                            title: "Profile",
                            subtitle: "Edit your profile information",
                            color: .blue
                        )
                    }

                    NavigationLink(destination: AccountSettingsScreen()) {
                        SettingsRow(
                            icon: "person.badge.key",
                            title: "Account Settings",
                            subtitle: "Email, password, and security",
                            color: .green
                        )
                    }

                    NavigationLink(destination: PrivacySettingsScreen()) {
                        SettingsRow(
                            icon: "shield.lefthalf.filled",
                            title: "Privacy Settings",
                            subtitle: "Control your privacy and data",
                            color: .orange
                        )
                    }
                }

                // Preferences Section
                Section("Preferences") {
                    NavigationLink(destination: NotificationSettingsScreen()) {
                        SettingsRow(
                            icon: "bell.badge",
                            title: "Notifications",
                            subtitle: "Push notifications, email alerts",
                            color: .red
                        )
                    }

                    NavigationLink(destination: ThemeSettingsScreen()) {
                        SettingsRow(
                            icon: "paintbrush.pointed",
                            title: "Theme",
                            subtitle: "Light, dark, or system theme",
                            color: .purple
                        )
                    }

                    NavigationLink(destination: LanguageSettingsScreen()) {
                        SettingsRow(
                            icon: "globe",
                            title: "Language",
                            subtitle: "Choose your preferred language",
                            color: .cyan
                        )
                    }
                }

                // App Section
                Section("App") {
                    Button(action: showStorageInfo) {
                        SettingsRow(
                            icon: "externaldrive",
                            title: "Storage",
                            subtitle: "Manage app data and cache",
                            color: .gray
                        )
                    }
                    .foregroundColor(.primary)

                    Button(action: showComingSoon) {
                        SettingsRow(
                            icon: "square.and.arrow.down",
                            title: "Downloads",
                            subtitle: "Manage downloaded content",
                            color: .teal
                        )
                    }
                    .foregroundColor(.primary)

                    Button(action: showComingSoon) {
                        SettingsRow(
                            icon: "icloud",
                            title: "Backup & Sync",
                            subtitle: "Sync your data across devices",
                            color: .indigo
                        )
                    }
                    .foregroundColor(.primary)
                }

                // Support Section
                Section("Support") {
                    NavigationLink(destination: HelpSupportScreen()) {
                        SettingsRow(
                            icon: "questionmark.circle",
                            title: "Help & Support",
                            subtitle: "FAQ, contact us, troubleshooting",
                            color: .blue
                        )
                    }

                    Button(action: showFeedbackSheet) {
                        SettingsRow(
                            icon: "exclamationmark.bubble",
                            title: "Send Feedback",
                            subtitle: "Help us improve the app",
                            color: .yellow
                        )
                    }
                    .foregroundColor(.primary)

                    Button(action: showRateApp) {
                        SettingsRow(
                            icon: "star",
                            title: "Rate App",
                            subtitle: "Rate us on the App Store",
                            color: .orange
                        )
                    }
                    .foregroundColor(.primary)
                }

                // About Section
                Section("About") {
                    NavigationLink(destination: AboutScreen()) {
                        SettingsRow(
                            icon: "info.circle",
                            title: "About",
                            subtitle: "Version, terms, privacy policy",
                            color: .gray
                        )
                    }

                    Button(action: checkForUpdates) {
                        SettingsRow(
                            icon: "arrow.down.circle",
                            title: "Check for Updates",
                            subtitle: "Version 1.0.0 (Latest)",
                            color: .green
                        )
                    }
                    .foregroundColor(.primary)
                }

                // Sign Out Section
                Section {
                    Button(action: { showingLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.red)
                                .frame(width: 24, height: 24)

                            Text("Sign Out")
                                .foregroundColor(.red)
                                .fontWeight(.medium)

                            Spacer()
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Sign Out", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Sign Out", role: .destructive) {
                    // Handle logout
                }
            } message: {
                Text("Are you sure you want to sign out?")
            }
        }
    }

    private func showStorageInfo() {
        // Show storage information
    }

    private func showComingSoon() {
        // Show coming soon alert
    }

    private func showFeedbackSheet() {
        // Show feedback sheet
    }

    private func showRateApp() {
        // Show rate app alert
    }

    private func checkForUpdates() {
        // Check for app updates
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .padding(8)
                .background(color)
                .cornerRadius(6)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    SettingsScreen()
}