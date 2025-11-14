import SwiftUI

struct HomeView: View {
    // MARK: - Properties

    @StateObject private var viewModel = HomeViewModel()
    @State private var showingUserDetail = false
    @State private var selectedUser: User?

    // MARK: - Body

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                if viewModel.isLoading && viewModel.filteredUsers.isEmpty {
                    LoadingView()
                } else if viewModel.filteredUsers.isEmpty {
                    EmptyStateView()
                } else {
                    UserListView(
                        users: viewModel.filteredUsers,
                        onUserTap: { user in
                            selectedUser = user
                            showingUserDetail = true
                        }
                    )
                }
            }
            .navigationTitle("Home")
            .refreshable {
                await viewModel.refreshData()
            }
            .sheet(isPresented: $showingUserDetail) {
                if let user = selectedUser {
                    UserDetailView(user: user)
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

// MARK: - Search Bar

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search users...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            if !text.isEmpty {
                Button("Clear") {
                    text = ""
                }
                .foregroundColor(.blue)
            }
        }
    }
}

// MARK: - User List View

struct UserListView: View {
    let users: [User]
    let onUserTap: (User) -> Void

    var body: some View {
        List(users) { user in
            UserRowView(user: user)
                .onTapGesture {
                    onUserTap(user)
                }
        }
        .listStyle(PlainListStyle())
    }
}

// MARK: - User Row View

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: user.profileImageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(.gray.opacity(0.3))
                    .overlay(
                        Text(user.initials)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    )
            }
            .frame(width: 50, height: 50)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Empty State View

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text("No users found")
                .font(.title2)
                .fontWeight(.semibold)

            Text("Try adjusting your search or pull to refresh")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - User Detail View

struct UserDetailView: View {
    let user: User
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                AsyncImage(url: user.profileImageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(.gray.opacity(0.3))
                        .overlay(
                            Text(user.initials)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        )
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())

                VStack(spacing: 8) {
                    Text(user.name)
                        .font(.title)
                        .fontWeight(.bold)

                    Text(user.email)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    DetailRow(title: "User ID", value: user.id.uuidString)
                    DetailRow(title: "Created", value: DateFormatter.displayFormatter.string(from: user.createdAt))
                    DetailRow(title: "Updated", value: DateFormatter.displayFormatter.string(from: user.updatedAt))
                }
                .padding()
                .background(.quaternary.opacity(0.5))
                .cornerRadius(12)

                Spacer()
            }
            .padding()
            .navigationTitle("User Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Detail Row

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Text(value)
                .font(.body)
                .foregroundColor(.primary)
        }
    }
}

// MARK: - Extensions

extension DateFormatter {
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
}

// MARK: - Preview

#Preview {
    HomeView()
        .environmentObject(AppState())
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}