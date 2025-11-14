import SwiftUI

struct StoriesScreen: View {
    let username: String?
    @StateObject private var viewModel = StoriesViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var dragOffset = CGSize.zero

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if !viewModel.storyUsers.isEmpty {
                TabView(selection: $viewModel.currentUserIndex) {
                    ForEach(viewModel.storyUsers.indices, id: \.self) { userIndex in
                        StoryUserView(
                            user: viewModel.storyUsers[userIndex],
                            currentStoryIndex: $viewModel.currentStoryIndex,
                            isPaused: $viewModel.isPaused,
                            onNextStory: viewModel.nextStory,
                            onPreviousStory: viewModel.previousStory,
                            onClose: { dismiss() }
                        )
                        .tag(userIndex)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onChange(of: viewModel.currentUserIndex) { _ in
                    viewModel.userChanged()
                }

                // Story progress bars
                VStack {
                    StoryProgressBars(
                        stories: viewModel.currentUser?.stories ?? [],
                        currentIndex: viewModel.currentStoryIndex,
                        progress: viewModel.storyProgress
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()
                }

                // User info header
                VStack {
                    StoryHeaderView(
                        user: viewModel.currentUser,
                        currentStory: viewModel.currentStory,
                        isPaused: viewModel.isPaused,
                        onPauseToggle: viewModel.togglePause,
                        onClose: { dismiss() }
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    Spacer()
                }

                // Story caption
                if let caption = viewModel.currentStory?.caption {
                    VStack {
                        Spacer()

                        Text(caption)
                            .font(.body)
                            .foregroundColor(.white)
                            .padding(.all, 12)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 100)
                    }
                }

                // Bottom actions
                VStack {
                    Spacer()

                    StoryBottomActions(
                        onReply: { text in viewModel.sendReply(text) },
                        onLike: viewModel.likeStory,
                        onShare: viewModel.shareStory
                    )
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                }

                // Video play button (when paused)
                if viewModel.currentStory?.type == .video && viewModel.isPaused {
                    Button(action: viewModel.togglePause) {
                        Circle()
                            .fill(Color.black.opacity(0.6))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "play.fill")
                                    .font(.system(size: 30))
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadStories(username: username)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation
                }
                .onEnded { value in
                    if value.translation.y > 100 {
                        dismiss()
                    }
                    dragOffset = .zero
                }
        )
        .offset(y: dragOffset.height * 0.3)
    }
}

struct StoryUserView: View {
    let user: StoryUser
    @Binding var currentStoryIndex: Int
    @Binding var isPaused: Bool
    let onNextStory: () -> Void
    let onPreviousStory: () -> Void
    let onClose: () -> Void

    private var currentStory: Story? {
        guard currentStoryIndex < user.stories.count else { return nil }
        return user.stories[currentStoryIndex]
    }

    var body: some View {
        ZStack {
            if let story = currentStory {
                StoryContentView(story: story)
            }

            // Tap areas for navigation
            HStack {
                Rectangle()
                    .fill(Color.clear)
                    .onTapGesture {
                        onPreviousStory()
                    }
                    .onLongPressGesture(minimumDuration: 0.1) {
                        isPaused = true
                    } onPressingChanged: { pressing in
                        if !pressing {
                            isPaused = false
                        }
                    }

                Rectangle()
                    .fill(Color.clear)
                    .onTapGesture {
                        onNextStory()
                    }
                    .onLongPressGesture(minimumDuration: 0.1) {
                        isPaused = true
                    } onPressingChanged: { pressing in
                        if !pressing {
                            isPaused = false
                        }
                    }
            }
        }
    }
}

struct StoryContentView: View {
    let story: Story

    var body: some View {
        Group {
            if story.type == .video {
                // Video placeholder
                ZStack {
                    AsyncImage(url: URL(string: story.mediaUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }

                    Image(systemName: "play.circle")
                        .font(.system(size: 64))
                        .foregroundColor(.white.opacity(0.7))
                }
            } else {
                AsyncImage(url: URL(string: story.mediaUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 64))
                                .foregroundColor(.white)
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StoryProgressBars: View {
    let stories: [Story]
    let currentIndex: Int
    let progress: Double

    var body: some View {
        HStack(spacing: 4) {
            ForEach(stories.indices, id: \.self) { index in
                Rectangle()
                    .fill(Color.white.opacity(0.3))
                    .frame(height: 3)
                    .overlay(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: geometry.size.width * progressValue(for: index),
                                    height: 3
                                )
                        },
                        alignment: .leading
                    )
                    .cornerRadius(1.5)
            }
        }
    }

    private func progressValue(for index: Int) -> Double {
        if index < currentIndex {
            return 1.0
        } else if index == currentIndex {
            return progress
        } else {
            return 0.0
        }
    }
}

struct StoryHeaderView: View {
    let user: StoryUser?
    let currentStory: Story?
    let isPaused: Bool
    let onPauseToggle: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            if let user = user {
                AsyncImage(url: URL(string: user.avatar)) { image in
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
                    Text(user.username)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)

                    if let story = currentStory {
                        Text(formatTimestamp(story.timestamp))
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }

            Spacer()

            Button(action: onPauseToggle) {
                Image(systemName: isPaused ? "play.fill" : "pause.fill")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Menu {
                Button("Mute", action: {})
                Button("Report", action: {})
                Button("Share", action: {})
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.white)
            }

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
            }
        }
    }

    private func formatTimestamp(_ timestamp: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

struct StoryBottomActions: View {
    let onReply: (String) -> Void
    let onLike: () -> Void
    let onShare: () -> Void

    @State private var replyText = ""
    @FocusState private var isReplyFocused: Bool

    var body: some View {
        HStack(spacing: 12) {
            // Reply input
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: "https://example.com/current_user_avatar.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 24, height: 24)
                .clipShape(Circle())

                TextField("Reply...", text: $replyText)
                    .focused($isReplyFocused)
                    .textFieldStyle(.plain)
                    .foregroundColor(.white)
                    .onSubmit {
                        if !replyText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onReply(replyText)
                            replyText = ""
                        }
                    }

                Image(systemName: "face.smiling")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color.clear)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white, lineWidth: 1)
            )

            // Like button
            Button(action: onLike) {
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "heart")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
            }

            // Share button
            Button(action: onShare) {
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: "paperplane")
                            .font(.title2)
                            .foregroundColor(.white)
                    )
            }
        }
    }
}

@MainActor
class StoriesViewModel: ObservableObject {
    @Published var storyUsers: [StoryUser] = []
    @Published var currentUserIndex = 0
    @Published var currentStoryIndex = 0
    @Published var isPaused = false
    @Published var storyProgress = 0.0

    private var storyTimer: Timer?

    var currentUser: StoryUser? {
        guard currentUserIndex < storyUsers.count else { return nil }
        return storyUsers[currentUserIndex]
    }

    var currentStory: Story? {
        guard let user = currentUser,
              currentStoryIndex < user.stories.count else { return nil }
        return user.stories[currentStoryIndex]
    }

    func loadStories(username: String?) {
        storyUsers = [
            StoryUser(
                username: "alice_wonder",
                displayName: "Alice Wonder",
                avatar: "https://example.com/avatar3.jpg",
                stories: [
                    Story(
                        id: "1",
                        mediaUrl: "https://example.com/story1.jpg",
                        type: .image,
                        timestamp: Date().addingTimeInterval(-7200),
                        caption: "Beautiful morning! ☀️",
                        views: 156
                    ),
                    Story(
                        id: "2",
                        mediaUrl: "https://example.com/story2.mp4",
                        type: .video,
                        timestamp: Date().addingTimeInterval(-3600),
                        views: 203,
                        duration: 15
                    ),
                    Story(
                        id: "3",
                        mediaUrl: "https://example.com/story3.jpg",
                        type: .image,
                        timestamp: Date().addingTimeInterval(-1800),
                        caption: "Coffee time! ☕",
                        views: 89
                    )
                ]
            ),
            StoryUser(
                username: "bob_builder",
                displayName: "Bob Builder",
                avatar: "https://example.com/avatar4.jpg",
                stories: [
                    Story(
                        id: "4",
                        mediaUrl: "https://example.com/story4.jpg",
                        type: .image,
                        timestamp: Date().addingTimeInterval(-10800),
                        caption: "New project! 🏗️",
                        views: 234
                    ),
                    Story(
                        id: "5",
                        mediaUrl: "https://example.com/story5.mp4",
                        type: .video,
                        timestamp: Date().addingTimeInterval(-7200),
                        views: 167,
                        duration: 12
                    )
                ]
            )
        ]

        // Find specific user if provided
        if let username = username,
           let userIndex = storyUsers.firstIndex(where: { $0.username == username }) {
            currentUserIndex = userIndex
        }

        startStoryTimer()
    }

    func nextStory() {
        guard let user = currentUser else { return }

        if currentStoryIndex < user.stories.count - 1 {
            currentStoryIndex += 1
            startStoryTimer()
        } else {
            // Move to next user
            if currentUserIndex < storyUsers.count - 1 {
                currentUserIndex += 1
                currentStoryIndex = 0
                startStoryTimer()
            }
            // If no more stories, close would be handled by parent view
        }
    }

    func previousStory() {
        if currentStoryIndex > 0 {
            currentStoryIndex -= 1
            startStoryTimer()
        } else {
            // Move to previous user
            if currentUserIndex > 0 {
                currentUserIndex -= 1
                if let user = currentUser {
                    currentStoryIndex = user.stories.count - 1
                }
                startStoryTimer()
            }
        }
    }

    func userChanged() {
        currentStoryIndex = 0
        startStoryTimer()
    }

    func togglePause() {
        isPaused.toggle()
        if isPaused {
            pauseStoryTimer()
        } else {
            resumeStoryTimer()
        }
    }

    func sendReply(_ text: String) {
        // Send reply to story owner
    }

    func likeStory() {
        // Like the current story
    }

    func shareStory() {
        // Share the current story
    }

    private func startStoryTimer() {
        pauseStoryTimer()

        guard let story = currentStory else { return }

        let duration: TimeInterval = story.type == .video ? Double(story.duration ?? 5) : 5.0
        storyProgress = 0.0

        storyTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            if !self.isPaused {
                self.storyProgress += 0.1 / duration

                if self.storyProgress >= 1.0 {
                    self.storyProgress = 1.0
                    self.nextStory()
                }
            }
        }
    }

    private func pauseStoryTimer() {
        storyTimer?.invalidate()
        storyTimer = nil
    }

    private func resumeStoryTimer() {
        startStoryTimer()
    }

    deinit {
        pauseStoryTimer()
    }
}

enum StoryType {
    case image, video
}

struct Story: Identifiable {
    let id: String
    let mediaUrl: String
    let type: StoryType
    let timestamp: Date
    let caption: String?
    let views: Int
    let duration: Int?

    init(id: String, mediaUrl: String, type: StoryType, timestamp: Date, caption: String? = nil, views: Int, duration: Int? = nil) {
        self.id = id
        self.mediaUrl = mediaUrl
        self.type = type
        self.timestamp = timestamp
        self.caption = caption
        self.views = views
        self.duration = duration
    }
}

struct StoryUser: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let avatar: String
    let stories: [Story]
}

#Preview {
    StoriesScreen(username: nil)
}