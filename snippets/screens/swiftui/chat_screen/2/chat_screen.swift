import SwiftUI

struct ChatScreen: View {
    let username: String
    @StateObject private var viewModel = ChatViewModel()
    @State private var messageText = ""
    @FocusState private var isMessageFieldFocused: Bool
    @State private var showingAttachmentOptions = false

    var body: some View {
        VStack(spacing: 0) {
            // Chat messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }

                        if viewModel.isTyping {
                            TypingIndicator()
                                .id("typing")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                }
                .onAppear {
                    scrollToBottom(proxy: proxy)
                }
                .onChange(of: viewModel.messages.count) { _ in
                    scrollToBottom(proxy: proxy)
                }
            }

            // Message input
            MessageInputBar(
                text: $messageText,
                isFocused: $isMessageFieldFocused,
                onSend: {
                    viewModel.sendMessage(messageText)
                    messageText = ""
                },
                onAttachment: {
                    showingAttachmentOptions = true
                },
                onVoiceRecord: {
                    viewModel.startVoiceRecording()
                }
            )
        }
        .navigationTitle(username)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text(username)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(viewModel.isOnline ? "Online" : "Last seen \(viewModel.lastSeen)")
                        .font(.caption)
                        .foregroundColor(viewModel.isOnline ? .green : .secondary)
                }
            }

            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { viewModel.startVideoCall() }) {
                    Image(systemName: "video")
                }

                Button(action: { viewModel.startVoiceCall() }) {
                    Image(systemName: "phone")
                }

                Menu {
                    Button("View Profile") { viewModel.viewProfile() }
                    Button("Mute") { viewModel.muteChat() }
                    Button("Block") { viewModel.blockUser() }
                    Button("Report") { viewModel.reportUser() }
                    Button("Clear Chat") { viewModel.clearChat() }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
        .onAppear {
            viewModel.loadMessages(for: username)
        }
        .actionSheet(isPresented: $showingAttachmentOptions) {
            ActionSheet(
                title: Text("Send"),
                buttons: [
                    .default(Text("Camera")) { viewModel.sendMedia(.camera) },
                    .default(Text("Photo Library")) { viewModel.sendMedia(.gallery) },
                    .default(Text("Document")) { viewModel.sendMedia(.document) },
                    .default(Text("Location")) { viewModel.sendLocation() },
                    .default(Text("Contact")) { viewModel.sendContact() },
                    .cancel()
                ]
            )
        }
    }

    private func scrollToBottom(proxy: ScrollViewProxy) {
        if let lastMessage = viewModel.messages.last {
            withAnimation(.easeOut(duration: 0.3)) {
                proxy.scrollTo(lastMessage.id, anchor: .bottom)
            }
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage

    private var isCurrentUser: Bool {
        message.senderId == "current_user"
    }

    var body: some View {
        HStack {
            if !isCurrentUser {
                AsyncImage(url: URL(string: "https://example.com/avatar3.jpg")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 24, height: 24)
                .clipShape(Circle())
            }

            if isCurrentUser {
                Spacer()
            }

            VStack(alignment: isCurrentUser ? .trailing : .leading, spacing: 4) {
                MessageContent(message: message, isCurrentUser: isCurrentUser)

                HStack(spacing: 4) {
                    Text(formatTime(message.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)

                    if isCurrentUser {
                        Image(systemName: message.isRead ? "checkmark.circle.fill" : "checkmark.circle")
                            .font(.caption2)
                            .foregroundColor(message.isRead ? .blue : .secondary)
                    }
                }
            }

            if !isCurrentUser {
                Spacer()
            }

            if isCurrentUser {
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
            }
        }
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        if Calendar.current.isDateInToday(date) {
            formatter.timeStyle = .short
        } else {
            formatter.dateStyle = .short
        }
        return formatter.string(from: date)
    }
}

struct MessageContent: View {
    let message: ChatMessage
    let isCurrentUser: Bool

    var body: some View {
        Group {
            switch message.type {
            case .text:
                if let text = message.text {
                    Text(text)
                        .font(.body)
                        .foregroundColor(isCurrentUser ? .white : .primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }

            case .image:
                if let imageUrl = message.imageUrl {
                    AsyncImage(url: URL(string: imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    }
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onTapGesture {
                        // Show full screen image
                    }
                }

            case .voice:
                VoiceMessageView(isCurrentUser: isCurrentUser)

            case .video:
                VideoMessageView(isCurrentUser: isCurrentUser)
            }
        }
    }
}

struct VoiceMessageView: View {
    let isCurrentUser: Bool
    @State private var isPlaying = false

    var body: some View {
        HStack {
            Button(action: { isPlaying.toggle() }) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .foregroundColor(isCurrentUser ? .white : .blue)
            }

            WaveformView()
                .frame(height: 20)

            Text("0:15")
                .font(.caption)
                .foregroundColor(isCurrentUser ? .white : .secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isCurrentUser ? Color.blue : Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(width: 200)
    }
}

struct VideoMessageView: View {
    let isCurrentUser: Bool

    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 200, height: 150)
            .overlay(
                Button(action: {
                    // Play video
                }) {
                    Image(systemName: "play.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct WaveformView: View {
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<20, id: \.self) { _ in
                Rectangle()
                    .fill(Color.blue.opacity(0.6))
                    .frame(width: 2, height: CGFloat.random(in: 4...16))
            }
        }
    }
}

struct TypingIndicator: View {
    @State private var animating = false

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://example.com/avatar3.jpg")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 24, height: 24)
            .clipShape(Circle())

            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animating ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: animating
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 20))

            Spacer()
        }
        .onAppear {
            animating = true
        }
    }
}

struct MessageInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let onSend: () -> Void
    let onAttachment: () -> Void
    let onVoiceRecord: () -> Void

    var body: some View {
        VStack {
            Divider()

            HStack(spacing: 12) {
                Button(action: onAttachment) {
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(.blue)
                }

                TextField("Type a message...", text: $text)
                    .focused(isFocused)
                    .textFieldStyle(.roundedBorder)

                Button(action: text.isEmpty ? onVoiceRecord : onSend) {
                    Image(systemName: text.isEmpty ? "mic.fill" : "paperplane.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isTyping = false
    @Published var isOnline = true
    @Published var lastSeen = "2 minutes ago"

    func loadMessages(for username: String) {
        messages = [
            ChatMessage(
                id: "1",
                senderId: "alice_wonder",
                text: "Hey! How are you?",
                timestamp: Date().addingTimeInterval(-7200),
                type: .text,
                isRead: true
            ),
            ChatMessage(
                id: "2",
                senderId: "current_user",
                text: "I'm good! Just working on some projects. How about you?",
                timestamp: Date().addingTimeInterval(-7100),
                type: .text,
                isRead: true
            ),
            ChatMessage(
                id: "3",
                senderId: "alice_wonder",
                imageUrl: "https://example.com/shared_image.jpg",
                timestamp: Date().addingTimeInterval(-3600),
                type: .image,
                isRead: true
            ),
            ChatMessage(
                id: "4",
                senderId: "alice_wonder",
                text: "Check out this cool photo I took!",
                timestamp: Date().addingTimeInterval(-3540),
                type: .text,
                isRead: true
            ),
            ChatMessage(
                id: "5",
                senderId: "current_user",
                text: "Wow, that's amazing! 😍",
                timestamp: Date().addingTimeInterval(-1800),
                type: .text,
                isRead: true
            ),
            ChatMessage(
                id: "6",
                senderId: "alice_wonder",
                text: "Thanks! Want to meet up this weekend?",
                timestamp: Date().addingTimeInterval(-300),
                type: .text,
                isRead: false
            )
        ]

        // Simulate typing
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isTyping = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.isTyping = false
            }
        }
    }

    func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let newMessage = ChatMessage(
            id: UUID().uuidString,
            senderId: "current_user",
            text: text,
            timestamp: Date(),
            type: .text,
            isRead: false
        )

        messages.append(newMessage)
    }

    func sendMedia(_ type: MediaType) {
        let newMessage = ChatMessage(
            id: UUID().uuidString,
            senderId: "current_user",
            imageUrl: "https://example.com/sent_media.jpg",
            timestamp: Date(),
            type: .image,
            isRead: false
        )

        messages.append(newMessage)
    }

    func sendLocation() {
        // Send location message
    }

    func sendContact() {
        // Send contact message
    }

    func startVoiceRecording() {
        let voiceMessage = ChatMessage(
            id: UUID().uuidString,
            senderId: "current_user",
            timestamp: Date(),
            type: .voice,
            isRead: false
        )

        messages.append(voiceMessage)
    }

    func startVideoCall() {
        // Start video call
    }

    func startVoiceCall() {
        // Start voice call
    }

    func viewProfile() {
        // Navigate to profile
    }

    func muteChat() {
        // Mute chat
    }

    func blockUser() {
        // Block user
    }

    func reportUser() {
        // Report user
    }

    func clearChat() {
        // Clear chat
        messages.removeAll()
    }
}

enum MediaType {
    case camera, gallery, document
}

struct ChatMessage: Identifiable {
    let id: String
    let senderId: String
    let text: String?
    let imageUrl: String?
    let timestamp: Date
    let type: ChatMessageType
    var isRead: Bool

    init(id: String, senderId: String, text: String? = nil, imageUrl: String? = nil, timestamp: Date, type: ChatMessageType, isRead: Bool) {
        self.id = id
        self.senderId = senderId
        self.text = text
        self.imageUrl = imageUrl
        self.timestamp = timestamp
        self.type = type
        self.isRead = isRead
    }
}

enum ChatMessageType {
    case text, image, voice, video
}

#Preview {
    NavigationView {
        ChatScreen(username: "alice_wonder")
    }
}