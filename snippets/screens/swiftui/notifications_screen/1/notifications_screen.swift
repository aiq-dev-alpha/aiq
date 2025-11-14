import SwiftUI

struct NotificationsScreen: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab picker
                Picker("Notifications", selection: $selectedTab) {
                    HStack {
                        Text("All")
                        if viewModel.unreadCount > 0 {
                            Text("\(viewModel.unreadCount)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    .tag(0)

                    HStack {
                        Text("Requests")
                        if viewModel.followRequests.count > 0 {
                            Text("\(viewModel.followRequests.count)")
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .clipShape(Capsule())
                        }
                    }
                    .tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Content
                TabView(selection: $selectedTab) {
                    AllNotificationsView(viewModel: viewModel)
                        .tag(0)

                    FollowRequestsView(viewModel: viewModel)
                        .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Notifications")
            .toolbar {
                if viewModel.hasUnreadNotifications {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Mark all read") {
                            viewModel.markAllAsRead()
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadNotifications()
        }
    }
}

struct AllNotificationsView: View {
    @ObservedObject var viewModel: NotificationsViewModel

    var body: some View {
        List {
            if viewModel.todayNotifications.isEmpty && viewModel.thisWeekNotifications.isEmpty {
                EmptyNotificationsView()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                if !viewModel.todayNotifications.isEmpty {
                    Section("Today") {
                        ForEach(viewModel.todayNotifications) { notification in
                            NotificationRow(
                                notification: notification,
                                onTap: {
                                    viewModel.handleNotificationTap(notification)
                                }
                            )
                        }
                    }
                }

                if !viewModel.thisWeekNotifications.isEmpty {
                    Section("This Week") {
                        ForEach(viewModel.thisWeekNotifications) { notification in
                            NotificationRow(
                                notification: notification,
                                onTap: {
                                    viewModel.handleNotificationTap(notification)
                                }
                            )
                        }
                    }
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshNotifications()
        }
    }
}

struct FollowRequestsView: View {
    @ObservedObject var viewModel: NotificationsViewModel

    var body: some View {
        List {
            if viewModel.followRequests.isEmpty {
                EmptyRequestsView()
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            } else {
                ForEach(viewModel.followRequests) { request in
                    FollowRequestRow(
                        notification: request,
                        onAccept: {
                            viewModel.acceptFollowRequest(request)
                        },
                        onDecline: {
                            viewModel.declineFollowRequest(request)
                        }
                    )
                }
            }
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.refreshNotifications()
        }
    }
}

struct NotificationRow: View {
    let notification: NotificationItem
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: notification.avatar)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                    // Notification type icon
                    Image(systemName: getNotificationIcon(notification.type))
                        .font(.caption)
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20)
                        .background(getNotificationColor(notification.type))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 2)
                        )
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(notification.username)
                            .fontWeight(.semibold)
                        + Text(" \(notification.content)")
                    }
                    .font(.subheadline)
                    .foregroundColor(.primary)

                    Text(formatTimestamp(notification.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                HStack {
                    if let imageUrl = notification.imageUrl {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                        }
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    if !notification.isRead {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 8, height: 8)
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func getNotificationIcon(_ type: NotificationType) -> String {
        switch type {
        case .like:
            return "heart.fill"
        case .comment:
            return "bubble.right.fill"
        case .follow, .follow_request:
            return "person.badge.plus.fill"
        case .mention:
            return "at"
        case .story:
            return "eye.fill"
        case .live:
            return "video.fill"
        }
    }

    private func getNotificationColor(_ type: NotificationType) -> Color {
        switch type {
        case .like:
            return .red
        case .comment:
            return .blue
        case .follow, .follow_request:
            return .green
        case .mention:
            return .orange
        case .story:
            return .purple
        case .live:
            return .pink
        }
    }

    private func formatTimestamp(_ timestamp: Date) -> String {
        let now = Date()
        let difference = now.timeIntervalSince(timestamp)

        if difference < 60 {
            return "now"
        } else if difference < 3600 {
            return "\(Int(difference / 60))m"
        } else if difference < 86400 {
            return "\(Int(difference / 3600))h"
        } else if difference < 604800 {
            return "\(Int(difference / 86400))d"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: timestamp)
        }
    }
}

struct FollowRequestRow: View {
    let notification: NotificationItem
    let onAccept: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: notification.avatar)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(width: 48, height: 48)
                .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(notification.username)
                        .font(.headline)
                        .fontWeight(.semibold)

                    Text(notification.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(formatTimestamp(notification.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }

            HStack(spacing: 12) {
                Button("Decline") {
                    onDecline()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )

                Button("Accept") {
                    onAccept()
                }
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(Color.blue)
                .cornerRadius(8)
            }
        }
        .padding(.vertical, 8)
    }

    private func formatTimestamp(_ timestamp: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}

struct EmptyNotificationsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text("No notifications yet")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text("Activity on your posts and profile will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
}

struct EmptyRequestsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.badge.plus")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text("No follow requests")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.gray)

                Text("Follow requests will appear here")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var allNotifications: [NotificationItem] = []
    @Published var todayNotifications: [NotificationItem] = []
    @Published var thisWeekNotifications: [NotificationItem] = []
    @Published var followRequests: [NotificationItem] = []

    var unreadCount: Int {
        allNotifications.filter { !$0.isRead }.count
    }

    var hasUnreadNotifications: Bool {
        unreadCount > 0
    }

    func loadNotifications() {
        allNotifications = [
            NotificationItem(
                id: "1",
                type: .like,
                username: "alice_wonder",
                avatar: "https://example.com/avatar3.jpg",
                content: "liked your post",
                imageUrl: "https://example.com/post1.jpg",
                timestamp: Date().addingTimeInterval(-300),
                isRead: false
            ),
            NotificationItem(
                id: "2",
                type: .follow,
                username: "bob_builder",
                avatar: "https://example.com/avatar4.jpg",
                content: "started following you",
                timestamp: Date().addingTimeInterval(-900),
                isRead: false
            ),
            NotificationItem(
                id: "3",
                type: .comment,
                username: "charlie_brown",
                avatar: "https://example.com/avatar5.jpg",
                content: "commented on your post: \"This is amazing! 🔥\"",
                imageUrl: "https://example.com/post2.jpg",
                timestamp: Date().addingTimeInterval(-3600),
                isRead: true
            ),
            NotificationItem(
                id: "4",
                type: .mention,
                username: "diana_prince",
                avatar: "https://example.com/avatar6.jpg",
                content: "mentioned you in a comment",
                imageUrl: "https://example.com/post3.jpg",
                timestamp: Date().addingTimeInterval(-7200),
                isRead: true
            ),
            NotificationItem(
                id: "5",
                type: .story,
                username: "edward_stark",
                avatar: "https://example.com/avatar7.jpg",
                content: "viewed your story",
                timestamp: Date().addingTimeInterval(-10800),
                isRead: true
            ),
            NotificationItem(
                id: "6",
                type: .like,
                username: "frank_castle",
                avatar: "https://example.com/avatar8.jpg",
                content: "and 12 others liked your post",
                imageUrl: "https://example.com/post4.jpg",
                timestamp: Date().addingTimeInterval(-18000),
                isRead: true
            ),
            NotificationItem(
                id: "7",
                type: .follow_request,
                username: "grace_hopper",
                avatar: "https://example.com/avatar9.jpg",
                content: "requested to follow you",
                timestamp: Date().addingTimeInterval(-86400),
                isRead: false
            ),
            NotificationItem(
                id: "8",
                type: .live,
                username: "henry_ford",
                avatar: "https://example.com/avatar10.jpg",
                content: "started a live video",
                timestamp: Date().addingTimeInterval(-93600),
                isRead: true
            )
        ]

        categorizeNotifications()
    }

    private func categorizeNotifications() {
        let now = Date()
        let oneDayAgo = now.addingTimeInterval(-86400)
        let oneWeekAgo = now.addingTimeInterval(-604800)

        todayNotifications = allNotifications.filter { notification in
            notification.timestamp > oneDayAgo && notification.type != .follow_request
        }

        thisWeekNotifications = allNotifications.filter { notification in
            notification.timestamp <= oneDayAgo && notification.timestamp > oneWeekAgo && notification.type != .follow_request
        }

        followRequests = allNotifications.filter { notification in
            notification.type == .follow_request
        }
    }

    func markAllAsRead() {
        for index in allNotifications.indices {
            allNotifications[index].isRead = true
        }
        categorizeNotifications()
    }

    func handleNotificationTap(_ notification: NotificationItem) {
        // Mark as read
        if let index = allNotifications.firstIndex(where: { $0.id == notification.id }) {
            allNotifications[index].isRead = true
        }

        // Navigate based on notification type
        switch notification.type {
        case .like, .comment, .mention:
            // Navigate to post detail
            break
        case .follow, .follow_request:
            // Navigate to user profile
            break
        case .story:
            // Navigate to stories
            break
        case .live:
            // Navigate to live stream
            break
        }

        categorizeNotifications()
    }

    func acceptFollowRequest(_ notification: NotificationItem) {
        followRequests.removeAll { $0.id == notification.id }
        allNotifications.removeAll { $0.id == notification.id }
    }

    func declineFollowRequest(_ notification: NotificationItem) {
        followRequests.removeAll { $0.id == notification.id }
        allNotifications.removeAll { $0.id == notification.id }
    }

    func refreshNotifications() async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        // Add new notification
        let newNotification = NotificationItem(
            id: UUID().uuidString,
            type: .like,
            username: "new_user",
            avatar: "https://example.com/new_avatar.jpg",
            content: "liked your recent post",
            timestamp: Date(),
            isRead: false
        )

        allNotifications.insert(newNotification, at: 0)
        categorizeNotifications()
    }
}

enum NotificationType {
    case like, comment, follow, follow_request, mention, story, live
}

struct NotificationItem: Identifiable {
    let id: String
    let type: NotificationType
    let username: String
    let avatar: String
    let content: String
    let imageUrl: String?
    let timestamp: Date
    var isRead: Bool

    init(id: String, type: NotificationType, username: String, avatar: String, content: String, imageUrl: String? = nil, timestamp: Date, isRead: Bool) {
        self.id = id
        self.type = type
        self.username = username
        self.avatar = avatar
        self.content = content
        self.imageUrl = imageUrl
        self.timestamp = timestamp
        self.isRead = isRead
    }
}

#Preview {
    NotificationsScreen()
}