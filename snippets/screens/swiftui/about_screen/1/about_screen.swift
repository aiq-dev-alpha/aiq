import SwiftUI

struct AboutScreen: View {
    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    // App Icon
                    RoundedRectangle(cornerRadius: 20)
                        .fill(
                            LinearGradient(
                                colors: [.blue, .blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "swift")
                                .font(.system(size: 60))
                                .foregroundColor(.white)
                        )

                    VStack(spacing: 8) {
                        Text("My Awesome App")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("Version 1.0.0 (Build 123)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }

            Section("App Information") {
                InfoRow(title: "Version", value: "1.0.0 (Build 123)")
                InfoRow(title: "Release Date", value: "January 15, 2024")
                InfoRow(title: "App Size", value: "45.2 MB")
                Button(action: showRatingDetails) {
                    HStack {
                        Text("Rating")
                        Spacer()
                        Text("4.8 ⭐ (1,234 reviews)")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
            }

            Section("Developer") {
                InfoRow(title: "Company", value: "Awesome Development Studio")
                Button(action: copyEmail) {
                    HStack {
                        Text("Contact")
                        Spacer()
                        Text("support@awesomeapp.com")
                            .foregroundColor(.secondary)
                        Image(systemName: "doc.on.doc")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
                Button(action: openWebsite) {
                    HStack {
                        Text("Website")
                        Spacer()
                        Text("www.awesomeapp.com")
                            .foregroundColor(.secondary)
                        Image(systemName: "arrow.up.right.square")
                            .foregroundColor(.blue)
                            .font(.caption)
                    }
                }
            }

            Section("Legal") {
                Button("Privacy Policy") {
                    // Open privacy policy
                }

                Button("Terms of Service") {
                    // Open terms of service
                }

                Button("Open Source Licenses") {
                    // Show licenses
                }
            }

            Section("Connect With Us") {
                HStack {
                    Spacer()

                    SocialButton(icon: "f.circle.fill", color: .blue) {
                        // Open Facebook
                    }

                    SocialButton(icon: "bird.circle.fill", color: .cyan) {
                        // Open Twitter
                    }

                    SocialButton(icon: "camera.circle.fill", color: .pink) {
                        // Open Instagram
                    }

                    Spacer()
                }
                .padding(.vertical)
            }

            Section("System Information") {
                Button(action: showSystemInfo) {
                    HStack {
                        Text("Platform")
                        Spacer()
                        Text("SwiftUI")
                            .foregroundColor(.secondary)
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }

                InfoRow(title: "iOS Version", value: "17.0+")
                InfoRow(title: "Device", value: "iPhone")
            }

            Section {
                VStack(spacing: 12) {
                    Text("Credits & Acknowledgments")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("• SwiftUI Team - For the amazing framework\n• Apple Design - For design inspiration\n• Unsplash - For beautiful placeholder images\n• Open Source Community - For countless packages")
                        .font(.body)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("Made with ❤️ using SwiftUI")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }
                .padding(.vertical)
            }

            Section {
                Text("© 2024 Awesome Development Studio\nAll rights reserved.")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func showRatingDetails() {
        // Show rating breakdown
    }

    private func copyEmail() {
        UIPasteboard.general.string = "support@awesomeapp.com"
        // Show copied confirmation
    }

    private func openWebsite() {
        // Open website URL
    }

    private func showSystemInfo() {
        // Show detailed system information
    }
}

struct InfoRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

struct SocialButton: View {
    let icon: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(color)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationView {
        AboutScreen()
    }
}