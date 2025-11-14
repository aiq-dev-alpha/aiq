import SwiftUI

struct FeedScreen: View {
    @StateObject private var viewModel = FeedViewModel()
    @State private var showingCreatePost = false

    var body: some View {
        NavigationView {
            RefreshableScrollView(onRefresh: viewModel.refreshFeed) {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.posts) { post in
                        PostCard(post: post, onLike: {
                            viewModel.toggleLike(for: post.id)
                        }, onComment: {
                            // Navigate to post detail
                        }, onShare: {
                            viewModel.sharePost(post)
                        })
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("SocialApp")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Navigate to stories
                    }) {
                        Image(systemName: "camera.circle")
                            .font(.title2)
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Navigate to notifications
                    }) {
                        Image(systemName: "heart")
                            .font(.title2)
                    }

                    Button(action: {
                        // Navigate to messages
                    }) {
                        Image(systemName: "paperplane")
                            .font(.title2)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreatePost) {
            CreatePostScreen()
        }
        .overlay(
            Button(action: {
                showingCreatePost = true
            }) {
                Image(systemName: "plus")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .clipShape(Circle())
            }
            .padding(.trailing, 20)
            .padding(.bottom, 20),
            alignment: .bottomTrailing
        )
    }
}

struct PostCard: View {
    let post: Post
    let onLike: () -> Void
    let onComment: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                AsyncImage(url: URL(string: post.userAvatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(post.username)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(post.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: {
                    // Show more options
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // Image
            AsyncImage(url: URL(string: post.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } placeholder: {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
            }
            .padding(.top, 8)

            // Actions
            HStack(spacing: 16) {
                Button(action: onLike) {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(post.isLiked ? .red : .primary)
                }

                Button(action: onComment) {
                    Image(systemName: "bubble.right")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                Button(action: onShare) {
                    Image(systemName: "paperplane")
                        .font(.title2)
                        .foregroundColor(.primary)
                }

                Spacer()

                Button(action: {
                    // Save post
                }) {
                    Image(systemName: "bookmark")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)

            // Likes and caption
            VStack(alignment: .leading, spacing: 4) {
                Text("\(post.likes) likes")
                    .font(.subheadline)
                    .fontWeight(.semibold)

                HStack {
                    Text(post.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    + Text(" \(post.caption)")
                        .font(.subheadline)
                }

                Button(action: onComment) {
                    Text("View all \(post.comments) comments")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
        .background(Color(UIColor.systemBackground))
    }
}

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = [
        Post(
            id: "1",
            username: "john_doe",
            userAvatar: "https://example.com/avatar1.jpg",
            imageUrl: "https://example.com/post1.jpg",
            caption: "Beautiful sunset at the beach! 🌅",
            likes: 156,
            comments: 23,
            timeAgo: "2h",
            isLiked: false
        ),
        Post(
            id: "2",
            username: "jane_smith",
            userAvatar: "https://example.com/avatar2.jpg",
            imageUrl: "https://example.com/post2.jpg",
            caption: "Morning coffee and coding session ☕️💻",
            likes: 89,
            comments: 12,
            timeAgo: "4h",
            isLiked: true
        )
    ]

    func refreshFeed() async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        // Refresh posts
    }

    func toggleLike(for postId: String) {
        if let index = posts.firstIndex(where: { $0.id == postId }) {
            posts[index].isLiked.toggle()
            posts[index].likes += posts[index].isLiked ? 1 : -1
        }
    }

    func sharePost(_ post: Post) {
        // Implement share functionality
    }
}

struct Post: Identifiable, Codable {
    let id: String
    let username: String
    let userAvatar: String
    let imageUrl: String
    let caption: String
    var likes: Int
    let comments: Int
    let timeAgo: String
    var isLiked: Bool
}

struct RefreshableScrollView<Content: View>: View {
    let onRefresh: () async -> Void
    let content: Content

    init(onRefresh: @escaping () async -> Void, @ViewBuilder content: () -> Content) {
        self.onRefresh = onRefresh
        self.content = content()
    }

    var body: some View {
        ScrollView {
            content
                .refreshable {
                    await onRefresh()
                }
        }
    }
}

#Preview {
    FeedScreen()
}