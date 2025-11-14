import SwiftUI

struct LiveStreamScreen: View {
    let streamerUsername: String?
    let isStreaming: Bool

    @StateObject private var viewModel = LiveStreamViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var messageText = ""
    @FocusState private var isMessageFieldFocused: Bool

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Video stream background
            StreamBackgroundView(
                isStreaming: viewModel.isStreaming,
                streamerUsername: streamerUsername ?? "current_user"
            )

            VStack(spacing: 0) {
                // Top overlay
                StreamHeaderView(
                    isStreaming: viewModel.isStreaming,
                    viewerCount: viewModel.viewerCount,
                    streamerUsername: streamerUsername,
                    onClose: { dismiss() }
                )
                .padding(.horizontal, 16)
                .padding(.top, 8)

                Spacer()

                // Chat overlay
                if viewModel.showChat {
                    ChatOverlayView(
                        messages: viewModel.messages,
                        onCloseChat: { viewModel.showChat = false }
                    )
                    .frame(maxHeight: 300)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 120)
                }

                Spacer()

                // Bottom controls
                StreamBottomControls(
                    isStreaming: viewModel.isStreaming,
                    showChat: viewModel.showChat,
                    likeCount: viewModel.likeCount,
                    isLiked: viewModel.isLiked,
                    messageText: $messageText,
                    isMessageFieldFocused: $isMessageFieldFocused,
                    streamerUsername: streamerUsername,
                    onToggleChat: { viewModel.showChat.toggle() },
                    onLike: viewModel.toggleLike,
                    onShare: viewModel.shareStream,
                    onSendMessage: { text in
                        viewModel.sendMessage(text)
                        messageText = ""
                    },
                    onStartStream: viewModel.startLiveStream,
                    onEndStream: viewModel.showEndStreamAlert
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }

            // Floating hearts animation
            if viewModel.showFloatingHeart {
                FloatingHeartView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            viewModel.showFloatingHeart = false
                        }
                    }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.initialize(
                streamerUsername: streamerUsername,
                isStreaming: isStreaming
            )
        }
        .alert("End Live Stream?", isPresented: $viewModel.showEndAlert) {
            Button("Cancel", role: .cancel) { }
            Button("End Stream", role: .destructive) {
                viewModel.endLiveStream()
                dismiss()
            }
        } message: {
            Text("Are you sure you want to end your live stream?")
        }
        .sheet(isPresented: $viewModel.showShareSheet) {
            ShareStreamSheet()
        }
    }
}

struct StreamBackgroundView: View {
    let isStreaming: Bool
    let streamerUsername: String

    var body: some View {
        if isStreaming {
            // Live stream background with gradient
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.purple.opacity(0.3),
                            Color.black,
                            Color.blue.opacity(0.3)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    VStack {
                        Image(systemName: "video.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.white.opacity(0.5))

                        Text("Live Stream")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Text("Camera feed would appear here")
                            .font(.body)
                            .foregroundColor(.white.opacity(0.7))
                    }
                )
        } else {
            // Stream ended background
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: "https://example.com/\(streamerUsername).jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())

                Text(streamerUsername)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                HStack {
                    Text("LIVE ENDED")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(4)
                }
            }
        }
    }
}

struct StreamHeaderView: View {
    let isStreaming: Bool
    let viewerCount: Int
    let streamerUsername: String?
    let onClose: () -> Void

    var body: some View {
        HStack {
            // Live indicator
            HStack(spacing: 8) {
                LiveIndicatorView(isStreaming: isStreaming)

                // Viewer count
                HStack(spacing: 4) {
                    Image(systemName: "eye")
                        .font(.caption)
                    Text(formatCount(viewerCount))
                        .font(.caption)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.black.opacity(0.5))
                .cornerRadius(12)
            }

            Spacer()

            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.black.opacity(0.5))
                    .clipShape(Circle())
            }
        }
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct LiveIndicatorView: View {
    let isStreaming: Bool
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        Text("LIVE")
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.red.opacity(isStreaming ? 0.9 : 0.5))
            .cornerRadius(4)
            .scaleEffect(pulseScale)
            .animation(
                isStreaming ?
                Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true) :
                .none,
                value: pulseScale
            )
            .onAppear {
                if isStreaming {
                    pulseScale = 1.1
                }
            }
    }
}

struct ChatOverlayView: View {
    let messages: [LiveMessage]
    let onCloseChat: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Chat header
            HStack {
                HStack(spacing: 8) {
                    Image(systemName: "bubble.left.and.bubble.right.fill")
                        .font(.caption)
                    Text("Live Chat")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)

                Spacer()

                Button(action: onCloseChat) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.white)
                }
            }
            .padding(.all, 12)
            .background(Color.black.opacity(0.6))

            // Messages
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(messages) { message in
                        ChatMessageView(message: message)
                    }
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 8)
            }
            .background(Color.black.opacity(0.3))
        }
        .cornerRadius(8)
    }
}

struct ChatMessageView: View {
    let message: LiveMessage

    var body: some View {
        HStack(alignment: .top) {
            Text(message.username + ":")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(message.isHighlighted ? .yellow : .white)
            + Text(" " + message.message)
                .font(.caption)
                .foregroundColor(.white)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            message.isHighlighted ?
            Color.yellow.opacity(0.2) :
            Color.clear
        )
        .cornerRadius(4)
    }
}

struct StreamBottomControls: View {
    let isStreaming: Bool
    let showChat: Bool
    let likeCount: Int
    let isLiked: Bool
    @Binding var messageText: String
    var isMessageFieldFocused: FocusState<Bool>.Binding
    let streamerUsername: String?

    let onToggleChat: () -> Void
    let onLike: () -> Void
    let onShare: () -> Void
    let onSendMessage: (String) -> Void
    let onStartStream: () -> Void
    let onEndStream: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            // Message input (only when streaming)
            if isStreaming {
                HStack(spacing: 8) {
                    TextField("Say something...", text: $messageText)
                        .focused(isMessageFieldFocused)
                        .textFieldStyle(.plain)
                        .foregroundColor(.white)
                        .onSubmit {
                            if !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                onSendMessage(messageText)
                            }
                        }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.5))
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }

            // Action buttons
            StreamActionButton(
                icon: showChat ? "bubble.left.and.bubble.right.fill" : "bubble.left.and.bubble.right",
                onTap: onToggleChat
            )

            StreamActionButton(
                icon: isLiked ? "heart.fill" : "heart",
                color: isLiked ? .red : .white,
                count: likeCount,
                onTap: onLike
            )

            StreamActionButton(
                icon: "square.and.arrow.up",
                onTap: onShare
            )

            // Stream control buttons
            if !isStreaming && streamerUsername == nil {
                Button("Go Live") {
                    onStartStream()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .cornerRadius(8)
            }

            if isStreaming && streamerUsername == nil {
                Button("End") {
                    onEndStream()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .cornerRadius(8)
            }
        }
    }
}

struct StreamActionButton: View {
    let icon: String
    let color: Color
    let count: Int?
    let onTap: () -> Void

    init(icon: String, color: Color = .white, count: Int? = nil, onTap: @escaping () -> Void) {
        self.icon = icon
        self.color = color
        self.count = count
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Circle()
                    .fill(Color.black.opacity(0.5))
                    .frame(width: 48, height: 48)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(color)
                    )

                if let count = count {
                    Text(formatCount(count))
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct FloatingHeartView: View {
    @State private var offset = CGSize.zero
    @State private var opacity = 1.0
    @State private var scale = 0.1

    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(.red)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .offset(offset)
                    .onAppear {
                        withAnimation(.easeOut(duration: 2.0)) {
                            offset = CGSize(width: 0, height: -300)
                            opacity = 0.0
                            scale = 1.5
                        }
                    }
                Spacer()
            }
        }
    }
}

struct ShareStreamSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Share Live Stream")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 20)

                VStack(spacing: 16) {
                    ShareOption(
                        icon: "doc.on.doc",
                        title: "Copy Link",
                        action: {
                            dismiss()
                        }
                    )

                    ShareOption(
                        icon: "plus.rectangle.on.rectangle",
                        title: "Share to Story",
                        action: {
                            dismiss()
                        }
                    )

                    ShareOption(
                        icon: "paperplane",
                        title: "Send to Friends",
                        action: {
                            dismiss()
                        }
                    )
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .navigationTitle("Share")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct ShareOption: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .frame(width: 24)
                Text(title)
                    .font(.body)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .foregroundColor(.primary)
            .padding(.vertical, 12)
        }
    }
}

@MainActor
class LiveStreamViewModel: ObservableObject {
    @Published var isStreaming = false
    @Published var viewerCount = 1247
    @Published var likeCount = 3456
    @Published var isLiked = false
    @Published var showChat = true
    @Published var messages: [LiveMessage] = []
    @Published var showFloatingHeart = false
    @Published var showEndAlert = false
    @Published var showShareSheet = false

    private var messageSimulationTimer: Timer?

    func initialize(streamerUsername: String?, isStreaming: Bool) {
        self.isStreaming = isStreaming

        // Sample messages
        messages = [
            LiveMessage(
                id: "1",
                username: "viewer1",
                message: "Great stream! 🔥",
                timestamp: Date().addingTimeInterval(-120),
                isHighlighted: false
            ),
            LiveMessage(
                id: "2",
                username: "viewer2",
                message: "Hello everyone! 👋",
                timestamp: Date().addingTimeInterval(-60),
                isHighlighted: false
            ),
            LiveMessage(
                id: "3",
                username: "moderator",
                message: "Welcome to the stream!",
                timestamp: Date().addingTimeInterval(-30),
                isHighlighted: true
            )
        ]

        if isStreaming {
            startMessageSimulation()
        }
    }

    func toggleLike() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1

        if isLiked {
            showFloatingHeart = true
        }
    }

    func sendMessage(_ text: String) {
        let newMessage = LiveMessage(
            id: UUID().uuidString,
            username: "You",
            message: text,
            timestamp: Date(),
            isHighlighted: false
        )

        messages.append(newMessage)
    }

    func shareStream() {
        showShareSheet = true
    }

    func startLiveStream() {
        isStreaming = true
        viewerCount = 1
        startMessageSimulation()
    }

    func showEndStreamAlert() {
        showEndAlert = true
    }

    func endLiveStream() {
        isStreaming = false
        stopMessageSimulation()
    }

    private func startMessageSimulation() {
        messageSimulationTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if self.isStreaming {
                let newMessage = LiveMessage(
                    id: UUID().uuidString,
                    username: "random_viewer",
                    message: "This is amazing! 😍",
                    timestamp: Date(),
                    isHighlighted: false
                )
                self.messages.append(newMessage)
                self.viewerCount += Int.random(in: 0...5)
            }
        }
    }

    private func stopMessageSimulation() {
        messageSimulationTimer?.invalidate()
        messageSimulationTimer = nil
    }

    deinit {
        stopMessageSimulation()
    }
}

struct LiveMessage: Identifiable {
    let id: String
    let username: String
    let message: String
    let timestamp: Date
    let isHighlighted: Bool
}

#Preview {
    LiveStreamScreen(streamerUsername: nil, isStreaming: true)
}