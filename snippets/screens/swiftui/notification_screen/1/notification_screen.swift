import SwiftUI

struct NotificationScreenTheme {
    var backgroundColor: Color = Color(.systemGroupedBackground)
    var cardBackground: Color = Color(.systemBackground)
    var primaryColor: Color = .blue
    var textPrimary: Color = .primary
    var textSecondary: Color = .secondary
    var unreadColor: Color = .blue.opacity(0.1)
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let timestamp: Date
    let icon: String
    let iconColor: Color
    let isRead: Bool
}

struct NotificationScreen: View {
    @State private var notifications: [NotificationItem] = [
        NotificationItem(
            title: "New Message",
            message: "You have a new message from Sarah",
            timestamp: Date().addingTimeInterval(-300),
            icon: "envelope.fill",
            iconColor: .blue,
            isRead: false
        ),
        NotificationItem(
            title: "Task Completed",
            message: "Your export has been completed successfully",
            timestamp: Date().addingTimeInterval(-3600),
            icon: "checkmark.circle.fill",
            iconColor: .green,
            isRead: false
        ),
        NotificationItem(
            title: "System Update",
            message: "A new version is available",
            timestamp: Date().addingTimeInterval(-7200),
            icon: "arrow.down.circle.fill",
            iconColor: .orange,
            isRead: true
        )
    ]

    @State private var selectedFilter: String = "all"
    var theme: NotificationScreenTheme = NotificationScreenTheme()

    var filteredNotifications: [NotificationItem] {
        switch selectedFilter {
        case "unread":
            return notifications.filter { !$0.isRead }
        case "read":
            return notifications.filter { $0.isRead }
        default:
            return notifications
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                filterButtons

                if filteredNotifications.isEmpty {
                    emptyState
                } else {
                    notificationList
                }
            }
            .navigationTitle("Notifications")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Mark All Read") {
                        markAllAsRead()
                    }
                    .font(.subheadline)
                }
            }
            .background(theme.backgroundColor)
        }
    }

    private var filterButtons: some View {
        HStack(spacing: 12) {
            FilterButton(
                title: "All",
                isSelected: selectedFilter == "all",
                theme: theme
            ) {
                selectedFilter = "all"
            }

            FilterButton(
                title: "Unread",
                isSelected: selectedFilter == "unread",
                theme: theme
            ) {
                selectedFilter = "unread"
            }

            FilterButton(
                title: "Read",
                isSelected: selectedFilter == "read",
                theme: theme
            ) {
                selectedFilter = "read"
            }

            Spacer()
        }
        .padding()
        .background(theme.cardBackground)
    }

    private var notificationList: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(filteredNotifications) { notification in
                    NotificationCard(
                        notification: notification,
                        theme: theme,
                        onTap: {
                            markAsRead(notification)
                        }
                    )

                    Divider()
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(theme.textSecondary)

            Text("No Notifications")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.textPrimary)

            Text("You're all caught up!")
                .font(.subheadline)
                .foregroundColor(theme.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func markAsRead(_ notification: NotificationItem) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications[index] = NotificationItem(
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                icon: notification.icon,
                iconColor: notification.iconColor,
                isRead: true
            )
        }
    }

    private func markAllAsRead() {
        notifications = notifications.map { notification in
            NotificationItem(
                title: notification.title,
                message: notification.message,
                timestamp: notification.timestamp,
                icon: notification.icon,
                iconColor: notification.iconColor,
                isRead: true
            )
        }
    }
}

struct NotificationCard: View {
    let notification: NotificationItem
    let theme: NotificationScreenTheme
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                Circle()
                    .fill(notification.iconColor.opacity(0.2))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: notification.icon)
                            .foregroundColor(notification.iconColor)
                            .font(.system(size: 18))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text(notification.title)
                        .font(.headline)
                        .foregroundColor(theme.textPrimary)

                    Text(notification.message)
                        .font(.subheadline)
                        .foregroundColor(theme.textSecondary)
                        .lineLimit(2)

                    Text(timeAgo(from: notification.timestamp))
                        .font(.caption)
                        .foregroundColor(theme.textSecondary)
                }

                Spacer()

                if !notification.isRead {
                    Circle()
                        .fill(theme.primaryColor)
                        .frame(width: 8, height: 8)
                }
            }
            .padding()
            .background(notification.isRead ? theme.cardBackground : theme.unreadColor)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            let minutes = Int(interval / 60)
            return "\(minutes)m ago"
        } else if interval < 86400 {
            let hours = Int(interval / 3600)
            return "\(hours)h ago"
        } else {
            let days = Int(interval / 86400)
            return "\(days)d ago"
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let theme: NotificationScreenTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? theme.primaryColor : Color.clear)
                .foregroundColor(isSelected ? .white : theme.textPrimary)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.clear : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
