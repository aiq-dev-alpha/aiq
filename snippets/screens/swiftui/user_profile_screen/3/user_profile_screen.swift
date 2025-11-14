import SwiftUI

struct UserProfileScreen: View {
    let username: String
    @StateObject private var viewModel = UserProfileViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Profile header
                    ProfileHeaderView(
                        profile: viewModel.userProfile,
                        isCurrentUser: viewModel.isCurrentUser,
                        isFollowing: viewModel.isFollowing,
                        onEditProfile: { viewModel.editProfile() },
                        onShareProfile: { viewModel.shareProfile() },
                        onToggleFollow: { viewModel.toggleFollow() },
                        onMessage: { viewModel.sendMessage() },
                        onFollowers: { /* Navigate to followers */ },
                        onFollowing: { /* Navigate to following */ }
                    )

                    // Bio section
                    if !viewModel.userProfile.bio.isEmpty {
                        BioSectionView(
                            displayName: viewModel.userProfile.displayName,
                            bio: viewModel.userProfile.bio,
                            website: viewModel.userProfile.website
                        )
                    }

                    // Highlights
                    HighlightsSectionView(
                        highlights: viewModel.highlights,
                        isCurrentUser: viewModel.isCurrentUser,
                        onAddHighlight: { viewModel.addHighlight() },
                        onViewHighlight: { highlight in
                            // Navigate to stories
                        }
                    )

                    // Tab bar
                    TabBarView(selectedTab: $selectedTab)

                    // Content based on selected tab
                    TabContentView(
                        selectedTab: selectedTab,
                        posts: viewModel.posts,
                        onPostTap: { post in
                            // Navigate to post detail
                        }
                    )
                }
            }
            .navigationTitle(viewModel.userProfile.username)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if viewModel.isCurrentUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { viewModel.showOptionsMenu() }) {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                } else {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Report") { viewModel.reportUser() }
                            Button("Block") { viewModel.blockUser() }
                            Button("Copy Profile URL") { viewModel.copyProfileUrl() }
                        } label: {
                            Image(systemName: "ellipsis")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadUserProfile(username: username)
        }
    }
}

struct ProfileHeaderView: View {
    let profile: UserProfile
    let isCurrentUser: Bool
    let isFollowing: Bool
    let onEditProfile: () -> Void
    let onShareProfile: () -> Void
    let onToggleFollow: () -> Void
    let onMessage: () -> Void
    let onFollowers: () -> Void
    let onFollowing: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                // Profile picture
                AsyncImage(url: URL(string: profile.avatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())

                Spacer()

                // Stats
                HStack(spacing: 32) {
                    StatView(label: "Posts", count: profile.postsCount)

                    Button(action: onFollowers) {
                        StatView(label: "Followers", count: profile.followersCount)
                    }

                    Button(action: onFollowing) {
                        StatView(label: "Following", count: profile.followingCount)
                    }
                }
            }

            // Action buttons
            if isCurrentUser {
                HStack(spacing: 12) {
                    Button("Edit Profile", action: onEditProfile)
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)

                    Button("Share Profile", action: onShareProfile)
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
            } else {
                HStack(spacing: 12) {
                    Button(isFollowing ? "Following" : "Follow") {
                        onToggleFollow()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)

                    Button("Message", action: onMessage)
                        .buttonStyle(.bordered)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct StatView: View {
    let label: String
    let count: Int

    var body: some View {
        VStack(spacing: 2) {
            Text(formatCount(count))
                .font(.headline)
                .fontWeight(.bold)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct BioSectionView: View {
    let displayName: String
    let bio: String
    let website: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if !displayName.isEmpty {
                Text(displayName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
            }

            Text(bio)
                .font(.subheadline)

            if !website.isEmpty {
                Button(website) {
                    // Open website
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

struct HighlightsSectionView: View {
    let highlights: [HighlightStory]
    let isCurrentUser: Bool
    let onAddHighlight: () -> Void
    let onViewHighlight: (HighlightStory) -> Void

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                if isCurrentUser {
                    Button(action: onAddHighlight) {
                        VStack(spacing: 4) {
                            Circle()
                                .stroke(Color.gray, lineWidth: 1)
                                .frame(width: 64, height: 64)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundColor(.gray)
                                )

                            Text("New")
                                .font(.caption)
                                .foregroundColor(.primary)
                        }
                    }
                }

                ForEach(highlights) { highlight in
                    Button(action: { onViewHighlight(highlight) }) {
                        VStack(spacing: 4) {
                            AsyncImage(url: URL(string: highlight.cover)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 64, height: 64)
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                            )

                            Text(highlight.title)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
    }
}

struct TabBarView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            TabButton(
                icon: "grid",
                isSelected: selectedTab == 0,
                action: { selectedTab = 0 }
            )

            TabButton(
                icon: "play.rectangle",
                isSelected: selectedTab == 1,
                action: { selectedTab = 1 }
            )

            TabButton(
                icon: "person.crop.rectangle",
                isSelected: selectedTab == 2,
                action: { selectedTab = 2 }
            )

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color(UIColor.systemBackground))
    }
}

struct TabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isSelected ? .primary : .secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

struct TabContentView: View {
    let selectedTab: Int
    let posts: [UserPost]
    let onPostTap: (UserPost) -> Void

    var body: some View {
        Group {
            switch selectedTab {
            case 0:
                PostsGridView(posts: posts, onPostTap: onPostTap)
            case 1:
                ReelsGridView()
            case 2:
                TaggedGridView()
            default:
                EmptyView()
            }
        }
    }
}

struct PostsGridView: View {
    let posts: [UserPost]
    let onPostTap: (UserPost) -> Void

    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(posts) { post in
                Button(action: { onPostTap(post) }) {
                    AsyncImage(url: URL(string: post.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(1, contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    .clipped()
                }
            }
        }
        .padding(.horizontal, 2)
    }
}

struct ReelsGridView: View {
    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<6) { index in
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(0.75, contentMode: .fill)
                    .overlay(
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "play.fill")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                Text("\((index + 1) * 1000)")
                                    .foregroundColor(.white)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(4)
                        }
                    )
            }
        }
        .padding(.horizontal, 2)
    }
}

struct TaggedGridView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.crop.rectangle")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            VStack(spacing: 4) {
                Text("No Photos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text("Photos of you will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
    }
}

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var userProfile = UserProfile(
        username: "john_doe",
        displayName: "John Doe",
        bio: "Photographer 📸 | Travel enthusiast ✈️ | Coffee lover ☕️\nCapturing moments around the world",
        avatar: "https://example.com/avatar1.jpg",
        postsCount: 127,
        followersCount: 1524,
        followingCount: 892,
        isVerified: true,
        website: "www.johndoe.photography"
    )

    @Published var posts: [UserPost] = []
    @Published var highlights: [HighlightStory] = [
        HighlightStory(id: "1", title: "Travel", cover: "https://example.com/highlight1.jpg"),
        HighlightStory(id: "2", title: "Food", cover: "https://example.com/highlight2.jpg"),
        HighlightStory(id: "3", title: "Work", cover: "https://example.com/highlight3.jpg")
    ]

    @Published var isFollowing = false
    @Published var isCurrentUser = false

    func loadUserProfile(username: String) {
        isCurrentUser = username == "current_user"

        // Load sample posts
        posts = [
            UserPost(id: "1", imageUrl: "https://example.com/post1.jpg", caption: "Beautiful sunset", likes: 156, comments: 23),
            UserPost(id: "2", imageUrl: "https://example.com/post2.jpg", caption: "Morning coffee", likes: 89, comments: 12),
            UserPost(id: "3", imageUrl: "https://example.com/post3.jpg", caption: "City lights", likes: 234, comments: 45),
            UserPost(id: "4", imageUrl: "https://example.com/post4.jpg", caption: "Mountain view", likes: 312, comments: 67),
            UserPost(id: "5", imageUrl: "https://example.com/post5.jpg", caption: "Beach day", likes: 198, comments: 34),
            UserPost(id: "6", imageUrl: "https://example.com/post6.jpg", caption: "Street art", likes: 156, comments: 28)
        ]
    }

    func editProfile() {
        // Navigate to edit profile
    }

    func shareProfile() {
        // Share profile functionality
    }

    func toggleFollow() {
        isFollowing.toggle()
    }

    func sendMessage() {
        // Navigate to chat
    }

    func showOptionsMenu() {
        // Show options menu
    }

    func reportUser() {
        // Report user functionality
    }

    func blockUser() {
        // Block user functionality
    }

    func copyProfileUrl() {
        // Copy profile URL
    }

    func addHighlight() {
        // Add new highlight
    }
}

struct UserProfile {
    let username: String
    let displayName: String
    let bio: String
    let avatar: String
    let postsCount: Int
    let followersCount: Int
    let followingCount: Int
    let isVerified: Bool
    let website: String
}

struct UserPost: Identifiable {
    let id: String
    let imageUrl: String
    let caption: String
    let likes: Int
    let comments: Int
}

struct HighlightStory: Identifiable {
    let id: String
    let title: String
    let cover: String
}

#Preview {
    UserProfileScreen(username: "john_doe")
}