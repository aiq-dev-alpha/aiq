import SwiftUI

struct PostDetailScreen: View {
    let post: Post
    @StateObject private var viewModel = PostDetailViewModel()
    @State private var commentText = ""
    @FocusState private var isCommentFieldFocused: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Original post
                        PostDetailCard(
                            post: post,
                            onLike: { viewModel.toggleLike() },
                            onShare: { viewModel.sharePost() }
                        )

                        Divider()
                            .padding(.vertical, 16)

                        // Comments section
                        if !viewModel.comments.isEmpty {
                            VStack(alignment: .leading, spacing: 0) {
                                Text("Comments")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 16)

                                LazyVStack(spacing: 16) {
                                    ForEach(viewModel.comments) { comment in
                                        CommentRow(
                                            comment: comment,
                                            onLike: { viewModel.likeComment(comment.id) },
                                            onReply: { viewModel.replyToComment(comment.username) }
                                        )
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                            }
                        }
                    }
                }

                // Comment input
                CommentInputBar(
                    text: $commentText,
                    isFocused: $isCommentFieldFocused,
                    onSend: {
                        viewModel.postComment(commentText)
                        commentText = ""
                    }
                )
            }
            .navigationTitle("Post")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.sharePost() }) {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadComments()
        }
    }
}

struct PostDetailCard: View {
    let post: Post
    let onLike: () -> Void
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

                Menu {
                    Button("Report", action: {})
                    Button("Block User", action: {})
                    Button("Copy Link", action: {})
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)

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
            .padding(.top, 12)

            // Actions
            HStack(spacing: 16) {
                Button(action: onLike) {
                    Image(systemName: post.isLiked ? "heart.fill" : "heart")
                        .font(.title2)
                        .foregroundColor(post.isLiked ? .red : .primary)
                }

                Button(action: {
                    // Focus comment input
                }) {
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
            .padding(.horizontal, 16)
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
            }
            .padding(.horizontal, 16)
            .padding(.top, 4)
            .padding(.bottom, 16)
        }
    }
}

struct CommentRow: View {
    let comment: Comment
    let onLike: () -> Void
    let onReply: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: comment.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 32, height: 32)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(comment.username)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    + Text(" \(comment.text)")
                        .font(.subheadline)
                }

                HStack(spacing: 16) {
                    Text(comment.timeAgo)
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Button("\(comment.likes) likes") {
                        onLike()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)

                    Button("Reply") {
                        onReply()
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button(action: onLike) {
                Image(systemName: "heart")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CommentInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void

    var body: some View {
        VStack {
            Divider()

            HStack(spacing: 12) {
                AsyncImage(url: URL(string: "https://example.com/current_user_avatar.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())

                TextField("Add a comment...", text: $text)
                    .focused(isFocused)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

@MainActor
class PostDetailViewModel: ObservableObject {
    @Published var comments: [Comment] = []

    func loadComments() {
        // Sample comments
        comments = [
            Comment(
                id: "1",
                username: "alice_wonder",
                avatar: "https://example.com/avatar3.jpg",
                text: "Amazing shot! 📸",
                timeAgo: "1h",
                likes: 5
            ),
            Comment(
                id: "2",
                username: "bob_builder",
                avatar: "https://example.com/avatar4.jpg",
                text: "Love the colors in this photo",
                timeAgo: "30m",
                likes: 2
            ),
            Comment(
                id: "3",
                username: "charlie_brown",
                avatar: "https://example.com/avatar5.jpg",
                text: "Where was this taken?",
                timeAgo: "15m",
                likes: 1
            )
        ]
    }

    func toggleLike() {
        // Toggle like for post
    }

    func sharePost() {
        // Share post functionality
    }

    func likeComment(_ commentId: String) {
        if let index = comments.firstIndex(where: { $0.id == commentId }) {
            comments[index].likes += 1
        }
    }

    func replyToComment(_ username: String) {
        // Set reply context
    }

    func postComment(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newComment = Comment(
            id: UUID().uuidString,
            username: "current_user",
            avatar: "https://example.com/current_user_avatar.jpg",
            text: text,
            timeAgo: "now",
            likes: 0
        )

        comments.insert(newComment, at: 0)
    }
}

struct Comment: Identifiable, Codable {
    let id: String
    let username: String
    let avatar: String
    let text: String
    let timeAgo: String
    var likes: Int
}

#Preview {
    PostDetailScreen(post: Post(
        id: "1",
        username: "john_doe",
        userAvatar: "https://example.com/avatar1.jpg",
        imageUrl: "https://example.com/post1.jpg",
        caption: "Beautiful sunset at the beach! 🌅",
        likes: 156,
        comments: 23,
        timeAgo: "2h",
        isLiked: false
    ))
}