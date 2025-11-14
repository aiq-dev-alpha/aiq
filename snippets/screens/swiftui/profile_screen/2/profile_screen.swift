import SwiftUI

struct ProfileScreen: View {
    @State private var showingEditProfile = false
    @State private var showingShareSheet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Header
                    VStack(spacing: 16) {
                        ZStack(alignment: .bottomTrailing) {
                            AsyncImage(url: URL(string: "https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=400&q=80")) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Image(systemName: "person.circle.fill")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 80))
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())

                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                                .background(Color.white)
                                .clipShape(Circle())
                                .font(.system(size: 24))
                        }

                        VStack(spacing: 8) {
                            Text("John Doe")
                                .font(.title)
                                .fontWeight(.bold)

                            Text("@johndoe")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Text("Software Engineer | Flutter Developer | Tech Enthusiast\nBuilding amazing apps with Flutter 🚀")
                                .font(.body)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top, 20)

                    // Stats Section
                    HStack(spacing: 40) {
                        StatItem(label: "Posts", count: "128")
                        StatItem(label: "Following", count: "342")
                        StatItem(label: "Followers", count: "1.2K")
                    }

                    // Action Buttons
                    HStack(spacing: 16) {
                        Button(action: { showingEditProfile = true }) {
                            HStack {
                                Image(systemName: "pencil")
                                Text("Edit Profile")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }

                        Button(action: { showingShareSheet = true }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share")
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .foregroundColor(.blue)
                        }
                    }
                    .padding(.horizontal)

                    // Profile Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Profile Details")
                            .font(.headline)
                            .fontWeight(.bold)

                        VStack(spacing: 12) {
                            DetailItem(icon: "envelope", label: "Email", value: "john.doe@example.com")
                            DetailItem(icon: "phone", label: "Phone", value: "+1 (555) 123-4567")
                            DetailItem(icon: "location", label: "Location", value: "San Francisco, CA")
                            DetailItem(icon: "calendar", label: "Joined", value: "January 2023")
                            DetailItem(icon: "globe", label: "Website", value: "www.johndoe.dev")
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)

                    // Quick Actions
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Actions")
                            .font(.headline)
                            .fontWeight(.bold)

                        VStack(spacing: 0) {
                            NavigationLink(destination: SettingsScreen()) {
                                ActionItem(
                                    icon: "gearshape",
                                    title: "Settings",
                                    subtitle: "Manage your account settings"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Divider()

                            NavigationLink(destination: HelpSupportScreen()) {
                                ActionItem(
                                    icon: "questionmark.circle",
                                    title: "Help & Support",
                                    subtitle: "Get help and contact support"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())

                            Divider()

                            NavigationLink(destination: AboutScreen()) {
                                ActionItem(
                                    icon: "info.circle",
                                    title: "About",
                                    subtitle: "App version and information"
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)

                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditProfile = true
                    }
                }
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileScreen()
            }
            .sheet(isPresented: $showingShareSheet) {
                ShareSheet(items: ["Check out my profile!"])
            }
        }
    }
}

struct StatItem: View {
    let label: String
    let count: String

    var body: some View {
        VStack(spacing: 4) {
            Text(count)
                .font(.title2)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct DetailItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)

            Text("\(label):")
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text(value)
                .fontWeight(.regular)

            Spacer()
        }
    }
}

struct ActionItem: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)

                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    ProfileScreen()
}