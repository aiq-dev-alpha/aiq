import SwiftUI

struct MessagesScreen: View {
    @StateObject private var viewModel = MessagesViewModel()
    @State private var searchText = ""
    @State private var showingNewMessage = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                // Quick actions and active users
                QuickActionsView()

                // Conversations list
                List {
                    ForEach(viewModel.filteredConversations) { conversation in
                        ConversationRow(
                            conversation: conversation,
                            onTap: {
                                viewModel.openChat(conversation)
                            }
                        )
                        .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Delete") {
                                viewModel.deleteConversation(conversation.id)
                            }
                            .tint(.red)

                            Button("Archive") {
                                viewModel.archiveConversation(conversation.id)
                            }
                            .tint(.orange)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    await viewModel.refreshMessages()
                }
            }
            .navigationTitle("Messages")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { showingNewMessage = true }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadConversations()
        }
        .onChange(of: searchText) { text in
            viewModel.filterConversations(searchText: text)
        }
        .sheet(isPresented: $showingNewMessage) {
            NewMessageSheet()
        }
        .alert("Delete Conversation", isPresented: $viewModel.showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                viewModel.confirmDelete()
            }
        } message: {
            Text("This conversation will be deleted permanently.")
        }
    }
}

struct QuickActionsView: View {
    let activeUsers = [
        ActiveUser(id: "1", username: "alice_wonder", avatar: "https://example.com/avatar3.jpg", isOnline: true),
        ActiveUser(id: "2", username: "bob_builder", avatar: "https://example.com/avatar4.jpg", isOnline: true),
        ActiveUser(id: "3", username: "charlie_brown", avatar: "https://example.com/avatar5.jpg", isOnline: true),
        ActiveUser(id: "4", username: "diana_prince", avatar: "https://example.com/avatar6.jpg", isOnline: true),
        ActiveUser(id: "5", username: "edward_stark", avatar: "https://example.com/avatar7.jpg", isOnline: true)
    ]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                // Camera action
                QuickActionButton(
                    icon: "camera.fill",
                    label: "Camera",
                    action: {
                        // Open camera
                    }
                )

                // Your story
                QuickActionButton(
                    icon: "heart.fill",
                    label: "Your Story",
                    action: {
                        // View own story
                    }
                )

                // Active users
                ForEach(activeUsers) { user in
                    ActiveUserButton(user: user) {
                        // Open chat with user
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 12)
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    .frame(width: 56, height: 56)
                    .overlay(
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundColor(.primary)
                    )

                Text(label)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ActiveUserButton: View {
    let user: ActiveUser
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack {
                    AsyncImage(url: URL(string: user.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())

                    if user.isOnline {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 16, height: 16)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }

                Text(user.username.count > 8 ? String(user.username.prefix(8)) + "..." : user.username)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct ConversationRow: View {
    let conversation: Conversation
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack {
                    AsyncImage(url: URL(string: conversation.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                    if conversation.isOnline {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Circle()
                                    .fill(Color.green)
                                    .frame(width: 14, height: 14)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white, lineWidth: 2)
                                    )
                            }
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(conversation.displayName)
                            .font(.headline)
                            .fontWeight(conversation.unreadCount > 0 ? .bold : .medium)
                            .foregroundColor(.primary)

                        if conversation.unreadCount > 0 {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 8, height: 8)
                        }

                        Spacer()
                    }

                    HStack {
                        MessageTypeIcon(type: conversation.lastMessageType)

                        Text(conversation.lastMessage)
                            .font(.subheadline)
                            .foregroundColor(conversation.unreadCount > 0 ? .primary : .secondary)
                            .fontWeight(conversation.unreadCount > 0 ? .medium : .regular)
                            .lineLimit(1)

                        Spacer()
                    }
                }

                VStack(alignment: .trailing, spacing: 4) {
                    Text(conversation.timestamp)
                        .font(.caption)
                        .foregroundColor(conversation.unreadCount > 0 ? .blue : .secondary)

                    if conversation.unreadCount > 0 {
                        Text("\(conversation.unreadCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .background(Color.blue)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }
}

struct MessageTypeIcon: View {
    let type: MessageType

    var body: some View {
        Group {
            switch type {
            case .image:
                Image(systemName: "photo")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .video:
                Image(systemName: "video")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .voice:
                Image(systemName: "mic")
                    .font(.caption)
                    .foregroundColor(.secondary)
            case .text:
                EmptyView()
            }
        }
    }
}

struct NewMessageSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    let sampleContacts = [
        Contact(id: "1", username: "friend_1", displayName: "Friend One", avatar: "https://example.com/contact1.jpg"),
        Contact(id: "2", username: "friend_2", displayName: "Friend Two", avatar: "https://example.com/contact2.jpg"),
        Contact(id: "3", username: "friend_3", displayName: "Friend Three", avatar: "https://example.com/contact3.jpg")
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                List(sampleContacts) { contact in
                    Button(action: {
                        dismiss()
                        // Navigate to chat
                    }) {
                        HStack {
                            AsyncImage(url: URL(string: contact.avatar)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text(contact.displayName)
                                    .font(.headline)
                                Text("@\(contact.username)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()
                        }
                        .foregroundColor(.primary)
                    }
                    .buttonStyle(.plain)
                }
                .listStyle(.plain)
            }
            .navigationTitle("New Message")
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

@MainActor
class MessagesViewModel: ObservableObject {
    @Published var conversations: [Conversation] = []
    @Published var filteredConversations: [Conversation] = []
    @Published var showDeleteAlert = false

    private var conversationToDelete: String?

    func loadConversations() {
        conversations = [
            Conversation(
                id: "1",
                username: "alice_wonder",
                displayName: "Alice Wonder",
                avatar: "https://example.com/avatar3.jpg",
                lastMessage: "Hey! How are you doing?",
                timestamp: "2m",
                unreadCount: 2,
                isOnline: true,
                lastMessageType: .text
            ),
            Conversation(
                id: "2",
                username: "bob_builder",
                displayName: "Bob Builder",
                avatar: "https://example.com/avatar4.jpg",
                lastMessage: "Thanks for the photo!",
                timestamp: "1h",
                unreadCount: 0,
                isOnline: false,
                lastMessageType: .text
            ),
            Conversation(
                id: "3",
                username: "charlie_brown",
                displayName: "Charlie Brown",
                avatar: "https://example.com/avatar5.jpg",
                lastMessage: "Photo",
                timestamp: "3h",
                unreadCount: 1,
                isOnline: true,
                lastMessageType: .image
            ),
            Conversation(
                id: "4",
                username: "diana_prince",
                displayName: "Diana Prince",
                avatar: "https://example.com/avatar6.jpg",
                lastMessage: "Voice message",
                timestamp: "1d",
                unreadCount: 0,
                isOnline: false,
                lastMessageType: .voice
            ),
            Conversation(
                id: "5",
                username: "edward_stark",
                displayName: "Edward Stark",
                avatar: "https://example.com/avatar7.jpg",
                lastMessage: "Video",
                timestamp: "2d",
                unreadCount: 0,
                isOnline: true,
                lastMessageType: .video
            )
        ]

        filteredConversations = conversations
    }

    func filterConversations(searchText: String) {
        if searchText.isEmpty {
            filteredConversations = conversations
        } else {
            filteredConversations = conversations.filter { conversation in
                conversation.username.localizedCaseInsensitiveContains(searchText) ||
                conversation.displayName.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func openChat(_ conversation: Conversation) {
        // Mark as read
        if let index = conversations.firstIndex(where: { $0.id == conversation.id }) {
            conversations[index].unreadCount = 0
        }
        // Navigate to chat
    }

    func deleteConversation(_ id: String) {
        conversationToDelete = id
        showDeleteAlert = true
    }

    func confirmDelete() {
        guard let id = conversationToDelete else { return }

        conversations.removeAll { $0.id == id }
        filteredConversations.removeAll { $0.id == id }
        conversationToDelete = nil
    }

    func archiveConversation(_ id: String) {
        conversations.removeAll { $0.id == id }
        filteredConversations.removeAll { $0.id == id }
    }

    func refreshMessages() async {
        // Simulate network request
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Update conversations with new messages
        if let index = conversations.firstIndex(where: { $0.username == "alice_wonder" }) {
            conversations[index].lastMessage = "Just sent you something cool!"
            conversations[index].timestamp = "now"
            conversations[index].unreadCount += 1
        }

        filterConversations(searchText: "")
    }
}

struct Conversation: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let avatar: String
    var lastMessage: String
    var timestamp: String
    var unreadCount: Int
    let isOnline: Bool
    let lastMessageType: MessageType
}

struct ActiveUser: Identifiable {
    let id: String
    let username: String
    let avatar: String
    let isOnline: Bool
}

struct Contact: Identifiable {
    let id: String
    let username: String
    let displayName: String
    let avatar: String
}

enum MessageType {
    case text, image, video, voice
}

#Preview {
    MessagesScreen()
}