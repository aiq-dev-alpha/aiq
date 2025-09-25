import SwiftUI

struct ProfileView: View {
    // MARK: - Properties

    @StateObject private var viewModel = ProfileViewModel()
    @State private var showingEditProfile = false
    @State private var showingImagePicker = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView(
                        user: viewModel.currentUser,
                        isLoading: viewModel.isLoading,
                        onEditTap: {
                            showingEditProfile = true
                        },
                        onImageTap: {
                            showingImagePicker = true
                        }
                    )

                    ProfileStatsView(user: viewModel.currentUser)

                    ProfileActionsView(
                        onLogoutTap: {
                            Task {
                                await viewModel.logout()
                            }
                        }
                    )

                    Spacer(minLength: 100)
                }
                .padding()
            }
            .navigationTitle("Profile")
            .refreshable {
                await viewModel.refreshProfile()
            }
            .sheet(isPresented: $showingEditProfile) {
                EditProfileView(user: viewModel.currentUser) { updatedUser in
                    Task {
                        await viewModel.updateProfile(updatedUser)
                    }
                }
            }
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

// MARK: - Profile Header View

struct ProfileHeaderView: View {
    let user: User?
    let isLoading: Bool
    let onEditTap: () -> Void
    let onImageTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Button(action: onImageTap) {
                AsyncImage(url: user?.profileImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(.gray.opacity(0.3))
                        .overlay(
                            Group {
                                if isLoading {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Text(user?.initials ?? "?")
                                        .font(.largeTitle)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                }
                            }
                        )
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.quaternary, lineWidth: 4)
                )
                .overlay(
                    Image(systemName: "camera.fill")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Circle().fill(.blue))
                        .offset(x: 40, y: 40)
                )
            }
            .disabled(isLoading)

            VStack(spacing: 4) {
                HStack {
                    Text(user?.displayName ?? "Unknown User")
                        .font(.title2)
                        .fontWeight(.bold)

                    Button(action: onEditTap) {
                        Image(systemName: "pencil")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    .disabled(isLoading)
                }

                Text(user?.email ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Profile Stats View

struct ProfileStatsView: View {
    let user: User?

    var body: some View {
        VStack(spacing: 16) {
            Text("Account Information")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 12) {
                StatRow(
                    title: "Member since",
                    value: user?.createdAt.formatted(date: .abbreviated, time: .omitted) ?? "N/A",
                    icon: "calendar"
                )

                StatRow(
                    title: "Last updated",
                    value: user?.updatedAt.formatted(date: .abbreviated, time: .omitted) ?? "N/A",
                    icon: "clock"
                )

                StatRow(
                    title: "User ID",
                    value: user?.id.uuidString.prefix(8).uppercased() + "...",
                    icon: "person.badge.key"
                )
            }
            .padding()
            .background(.quaternary.opacity(0.5))
            .cornerRadius(12)
        }
    }
}

// MARK: - Profile Actions View

struct ProfileActionsView: View {
    let onLogoutTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Actions")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 8) {
                ActionButton(
                    title: "Export Data",
                    icon: "square.and.arrow.up",
                    action: {
                        // Implement export functionality
                    }
                )

                ActionButton(
                    title: "Privacy Settings",
                    icon: "lock.shield",
                    action: {
                        // Navigate to privacy settings
                    }
                )

                ActionButton(
                    title: "Support",
                    icon: "questionmark.circle",
                    action: {
                        // Navigate to support
                    }
                )

                Divider()

                ActionButton(
                    title: "Sign Out",
                    icon: "rectangle.portrait.and.arrow.right",
                    color: .red,
                    action: onLogoutTap
                )
            }
            .padding()
            .background(.quaternary.opacity(0.5))
            .cornerRadius(12)
        }
    }
}

// MARK: - Supporting Views

struct StatRow: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.body)
                    .foregroundColor(.primary)
            }

            Spacer()
        }
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void

    init(title: String, icon: String, color: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .frame(width: 20)

                Text(title)
                    .foregroundColor(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Edit Profile View

struct EditProfileView: View {
    let user: User?
    let onSave: (User) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var email: String

    init(user: User?, onSave: @escaping (User) -> Void) {
        self.user = user
        self.onSave = onSave
        self._name = State(initialValue: user?.name ?? "")
        self._email = State(initialValue: user?.email ?? "")
    }

    var body: some View {
        NavigationView {
            Form {
                Section("Personal Information") {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let user = user {
                            let updatedUser = User(
                                id: user.id,
                                name: name,
                                email: email,
                                profileImageURL: user.profileImageURL,
                                createdAt: user.createdAt,
                                updatedAt: Date()
                            )
                            onSave(updatedUser)
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                }
            }
        }
    }
}

// MARK: - Profile View Model

@MainActor
final class ProfileViewModel: BaseViewModel {
    @Published var currentUser: User?

    private let networkingService: NetworkingServiceProtocol
    private let persistenceService: PersistenceServiceProtocol

    init(
        networkingService: NetworkingServiceProtocol = NetworkingService.shared,
        persistenceService: PersistenceServiceProtocol = PersistenceService.shared
    ) {
        self.networkingService = networkingService
        self.persistenceService = persistenceService
        super.init()
        loadCurrentUser()
    }

    func refreshProfile() async {
        await performTask {
            try await self.fetchCurrentUser()
        }
    }

    func updateProfile(_ user: User) async {
        await performTask {
            let updatedUser = try await self.networkingService.updateUser(user, with: UserUpdateRequest(
                name: user.name,
                email: user.email,
                profileImageURL: user.profileImageURL
            ))
            try self.persistenceService.updateUser(updatedUser)
            self.currentUser = updatedUser
        }
    }

    func logout() async {
        // Implement logout logic
        currentUser = nil
    }

    private func loadCurrentUser() {
        // Load current user from persistence or set mock data
        currentUser = User.mock
    }

    private func fetchCurrentUser() async throws {
        // Implement current user fetching
        // For demo purposes, using mock data
        currentUser = User.mock
    }
}

// MARK: - Preview

#Preview {
    ProfileView()
        .environmentObject(AppState())
}