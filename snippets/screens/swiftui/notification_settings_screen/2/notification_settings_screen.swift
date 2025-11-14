import SwiftUI

struct NotificationSettingsScreen: View {
    @State private var pushNotificationsEnabled = true
    @State private var messagesNotifications = true
    @State private var followNotifications = true
    @State private var likeNotifications = false
    @State private var commentNotifications = true
    @State private var mentionNotifications = true
    @State private var systemNotifications = true

    @State private var emailNotificationsEnabled = true
    @State private var weeklyDigest = true
    @State private var promotionalEmails = false
    @State private var securityEmails = true

    @State private var soundEnabled = true
    @State private var vibrationEnabled = true
    @State private var quietHoursEnabled = false

    var body: some View {
        List {
            // Push Notifications
            Section("Push Notifications") {
                Toggle("Enable Push Notifications", isOn: $pushNotificationsEnabled)

                if pushNotificationsEnabled {
                    Group {
                        Toggle("Messages", isOn: $messagesNotifications)
                        Toggle("New Followers", isOn: $followNotifications)
                        Toggle("Likes", isOn: $likeNotifications)
                        Toggle("Comments", isOn: $commentNotifications)
                        Toggle("Mentions", isOn: $mentionNotifications)
                        Toggle("System Notifications", isOn: $systemNotifications)
                    }
                    .padding(.leading)
                }
            }

            // Email Notifications
            Section("Email Notifications") {
                Toggle("Enable Email Notifications", isOn: $emailNotificationsEnabled)

                if emailNotificationsEnabled {
                    Group {
                        Toggle("Weekly Digest", isOn: $weeklyDigest)
                        Toggle("Promotional Emails", isOn: $promotionalEmails)
                        Toggle("Security Alerts", isOn: $securityEmails)
                    }
                    .padding(.leading)
                }
            }

            // Sound & Vibration
            Section("Sound & Vibration") {
                Toggle("Sound", isOn: $soundEnabled)
                Toggle("Vibration", isOn: $vibrationEnabled)
            }

            // Quiet Hours
            Section("Quiet Hours") {
                Toggle("Enable Quiet Hours", isOn: $quietHoursEnabled)

                if quietHoursEnabled {
                    HStack {
                        Text("Start Time")
                        Spacer()
                        Text("10:00 PM")
                            .foregroundColor(.secondary)
                    }

                    HStack {
                        Text("End Time")
                        Spacer()
                        Text("7:00 AM")
                            .foregroundColor(.secondary)
                    }
                }
            }

            // Test Notification
            Section {
                Button("Send Test Notification") {
                    // Send test notification
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationView {
        NotificationSettingsScreen()
    }
}