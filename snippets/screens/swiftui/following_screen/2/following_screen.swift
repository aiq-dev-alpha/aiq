import SwiftUI

struct FollowingScreen: View {
    let username: String
    @StateObject private var viewModel = FollowingViewModel()
    @State private var searchText = ""
    @State private var showingSortOptions = false

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

                // Following list
                List {
                    ForEach(viewModel.filteredFollowing) { user in
                        FollowingRow(
                            user: user,
                            onUnfollow: {
                                viewModel.showUnfollowConfirmation(for: user)
                            },
                            onMessage: {
                                // Navigate to chat
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
                    await viewModel.refreshFollowing()
                }
            }
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingSortOptions = true }) {
                        Image(systemName: "arrow.up.arrow.down")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadFollowing(for: username)
        }
        .onChange(of: searchText) { text in
            viewModel.filterFollowing(searchText: text)
        }
        .onChange(of: viewModel.selectedCategory) { _ in
            viewModel.applyFilters()
        }
        .actionSheet(isPresented: $showingSortOptions) {
            ActionSheet(
                title: Text("Sort Following"),
                buttons: [
                    .default(Text("Sort A-Z")) { viewModel.sortFollowing(.alphabetical) },
                    .default(Text("Recently followed")) { viewModel.sortFollowing(.recent) },
                    .default(Text("Followed earliest")) { viewModel.sortFollowing(.earliest) },
                    .cancel()
                ]
            )
        }
        .alert("Unfollow User", isPresented: $viewModel.showUnfollowAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Unfollow", role: .destructive) {
                viewModel.confirmUnfollow()
            }
        } message: {
            if let user = viewModel.userToUnfollow {
                Text("Are you sure you want to unfollow \(user.username)?")
            }
        }
    }
}

struct FollowingRow: View {
    let user: FollowingUserModel
    let onUnfollow: () -> Void
    let onMessage: () -> Void
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
                HStack {
                    Button(action: onUserTap) {
                        Text(user.username)
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }

                    if user.isFollowedBy {
                        Text("Follows you")
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                            .foregroundColor(.secondary)
                    }
                }

                Text(user.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Followed \(user.followedDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            HStack(spacing: 8) {
                Button(action: onMessage) {
                    Image(systemName: "message")
                        .font(.system(size: 16))
                        .foregroundColor(.blue)
                }

                Button("Following") {
                    onUnfollow()
                }
                .font(.subheadline)
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
        }
    }
}

@MainActor
class FollowingViewModel: ObservableObject {
    @Published var following: [FollowingUserModel] = []
    @Published var filteredFollowing: [FollowingUserModel] = []
    @Published var selectedCategory = "All"
    @Published var navigationTitle = "Following"
    @Published var showUnfollowAlert = false
    @Published var userToUnfollow: FollowingUserModel?

    let categories = ["All", "Following you back", "Not following back", "Recently followed"]

    private var allFollowing: [FollowingUserModel] = []
    private var currentSearchText = ""

    enum SortType {
        case alphabetical, recent, earliest
    }

    func loadFollowing(for username: String) {
        // Sample following data
        allFollowing = [
            FollowingUserModel(
                id: "1",
                username: "alice_wonder",
                displayName: "Alice Wonder",
                avatar: "https://example.com/avatar3.jpg",
                isFollowing: true,
                isFollowedBy: true,
                followedDate: "2 months ago"
            ),
            FollowingUserModel(
                id: "2",
                username: "bob_builder",
                displayName: "Bob Builder",
                avatar: "https://example.com/avatar4.jpg",
                isFollowing: true,
                isFollowedBy: false,
                followedDate: "1 month ago"
            ),
            FollowingUserModel(
                id: "3",
                username: "charlie_brown",
                displayName: "Charlie Brown",
                avatar: "https://example.com/avatar5.jpg",
                isFollowing: true,
                isFollowedBy: true,
                followedDate: "3 weeks ago"
            ),
            FollowingUserModel(
                id: "4",
                username: "diana_prince",
                displayName: "Diana Prince",
                avatar: "https://example.com/avatar6.jpg",
                isFollowing: true,
                isFollowedBy: false,
                followedDate: "2 weeks ago"
            ),
            FollowingUserModel(
                id: "5",
                username: "edward_stark",
                displayName: "Edward Stark",
                avatar: "https://example.com/avatar7.jpg",
                isFollowing: true,
                isFollowedBy: true,
                followedDate: "1 week ago"
            ),
            FollowingUserModel(
                id: "6",
                username: "frank_castle",
                displayName: "Frank Castle",
                avatar: "https://example.com/avatar8.jpg",
                isFollowing: true,
                isFollowedBy: false,
                followedDate: "3 days ago"
            )
        ]

        following = allFollowing
        navigationTitle = "\(following.count) following"
        applyFilters()
    }

    func filterFollowing(searchText: String) {
        currentSearchText = searchText
        applyFilters()
    }

    func applyFilters() {
        var filtered = allFollowing

        // Apply category filter
        switch selectedCategory {
        case "Following you back":
            filtered = filtered.filter { $0.isFollowedBy }
        case "Not following back":
            filtered = filtered.filter { !$0.isFollowedBy }
        case "Recently followed":
            // Sort by most recent and take top 3
            filtered = filtered.sorted { user1, user2 in
                // In real app, use actual dates
                return user1.followedDate < user2.followedDate
            }.prefix(3).map { $0 }
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

        filteredFollowing = filtered
    }

    func sortFollowing(_ sortType: SortType) {
        switch sortType {
        case .alphabetical:
            allFollowing.sort { $0.username < $1.username }
        case .recent:
            allFollowing.sort { $0.followedDate < $1.followedDate }
        case .earliest:
            allFollowing.sort { $0.followedDate > $1.followedDate }
        }
        applyFilters()
    }

    func showUnfollowConfirmation(for user: FollowingUserModel) {
        userToUnfollow = user
        showUnfollowAlert = true
    }

    func confirmUnfollow() {
        guard let user = userToUnfollow else { return }

        if let index = allFollowing.firstIndex(where: { $0.id == user.id }) {
            allFollowing.remove(at: index)
            following = allFollowing
            navigationTitle = "\(following.count) following"
            applyFilters()
        }

        userToUnfollow = nil
    }

    func refreshFollowing() async {
        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Refresh data if needed
    }
}

struct FollowingUserModel: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let avatar: String
    var isFollowing: Bool
    let isFollowedBy: Bool
    let followedDate: String
}

#Preview {
    FollowingScreen(username: "john_doe")
}