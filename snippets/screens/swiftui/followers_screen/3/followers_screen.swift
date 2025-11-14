import SwiftUI

struct FollowersScreen: View {
    let username: String
    @StateObject private var viewModel = FollowersViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                // Category filters
                CategoryFilterBar(
                    selectedCategory: $viewModel.selectedCategory,
                    categories: viewModel.categories
                )

                // Followers list
                List {
                    ForEach(viewModel.filteredFollowers) { follower in
                        FollowerRow(
                            user: follower,
                            onToggleFollow: {
                                viewModel.toggleFollow(for: follower.id)
                            },
                            onUserTap: {
                                // Navigate to user profile
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.refreshFollowers()
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.loadFollowers(for: username)
        }
        .onChange(of: searchText) { text in
            viewModel.filterFollowers(searchText: text)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)

            TextField("Search followers...", text: $text)
                .textFieldStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct CategoryFilterBar: View {
    @Binding var selectedCategory: String
    let categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    FilterChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        onTap: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(title)
                .font(.subheadline)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .blue : .primary)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 1)
                )
                .cornerRadius(20)
        }
    }
}

struct FollowerRow: View {
    let user: UserModel
    let onToggleFollow: () -> Void
    let onUserTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onUserTap) {
                AsyncImage(url: URL(string: user.avatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 2) {
                Button(action: onUserTap) {
                    Text(user.username)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                }

                Text(user.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                if user.isFollowedBy && user.isFollowing {
                    Text("Follows you")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if user.username != "current_user" {
                Button(user.isFollowing ? "Following" : "Follow") {
                    onToggleFollow()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(user.isFollowing ? .primary : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 8)
                .background(user.isFollowing ? Color.gray.opacity(0.2) : Color.blue)
                .cornerRadius(8)
            }
        }
    }
}

@MainActor
class FollowersViewModel: ObservableObject {
    @Published var followers: [UserModel] = []
    @Published var filteredFollowers: [UserModel] = []
    @Published var selectedCategory = "All"
    @Published var navigationTitle = "Followers"

    let categories = ["All", "Following you back", "Not following back"]

    private var allFollowers: [UserModel] = []
    private var currentSearchText = ""

    func loadFollowers(for username: String) {
        // Sample followers data
        allFollowers = [
            UserModel(
                id: "1",
                username: "alice_wonder",
                displayName: "Alice Wonder",
                avatar: "https://example.com/avatar3.jpg",
                isFollowing: true,
                isFollowedBy: true
            ),
            UserModel(
                id: "2",
                username: "bob_builder",
                displayName: "Bob Builder",
                avatar: "https://example.com/avatar4.jpg",
                isFollowing: false,
                isFollowedBy: true
            ),
            UserModel(
                id: "3",
                username: "charlie_brown",
                displayName: "Charlie Brown",
                avatar: "https://example.com/avatar5.jpg",
                isFollowing: true,
                isFollowedBy: true
            ),
            UserModel(
                id: "4",
                username: "diana_prince",
                displayName: "Diana Prince",
                avatar: "https://example.com/avatar6.jpg",
                isFollowing: false,
                isFollowedBy: true
            ),
            UserModel(
                id: "5",
                username: "edward_stark",
                displayName: "Edward Stark",
                avatar: "https://example.com/avatar7.jpg",
                isFollowing: true,
                isFollowedBy: true
            )
        ]

        followers = allFollowers
        navigationTitle = "\(followers.count) followers"
        applyFilters()
    }

    func filterFollowers(searchText: String) {
        currentSearchText = searchText
        applyFilters()
    }

    func applyFilters() {
        var filtered = allFollowers

        // Apply category filter
        switch selectedCategory {
        case "Following you back":
            filtered = filtered.filter { $0.isFollowing }
        case "Not following back":
            filtered = filtered.filter { !$0.isFollowing }
        default:
            break
        }

        // Apply search filter
        if !currentSearchText.isEmpty {
            filtered = filtered.filter { user in
                user.username.localizedCaseInsensitiveContains(currentSearchText) ||
                user.displayName.localizedCaseInsensitiveContains(currentSearchText)
            }
        }

        filteredFollowers = filtered
    }

    func toggleFollow(for userId: String) {
        if let index = allFollowers.firstIndex(where: { $0.id == userId }) {
            allFollowers[index].isFollowing.toggle()
            applyFilters()
        }
    }

    func refreshFollowers() async {
        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Refresh data if needed
    }
}

struct UserModel: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let avatar: String
    var isFollowing: Bool
    let isFollowedBy: Bool
}

#Preview {
    FollowersScreen(username: "john_doe")
}