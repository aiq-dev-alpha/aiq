import SwiftUI

struct HelpSupportScreen: View {
    @State private var searchText = ""
    @State private var showingContactSheet = false

    private let faqItems = [
        FAQItem(
            question: "How do I reset my password?",
            answer: "To reset your password, go to Settings > Account Settings > Change Password. You can also use the 'Forgot Password' link on the login screen.",
            category: "Account"
        ),
        FAQItem(
            question: "How do I change my profile picture?",
            answer: "Go to your Profile, tap the Edit button, then tap on your profile picture to select a new one from your gallery or take a new photo.",
            category: "Profile"
        ),
        FAQItem(
            question: "Why am I not receiving notifications?",
            answer: "Check your notification settings in Settings > Notifications. Also make sure notifications are enabled for this app in your device settings.",
            category: "Notifications"
        ),
        FAQItem(
            question: "How do I delete my account?",
            answer: "Go to Settings > Account Settings > Delete Account. Please note that this action cannot be undone.",
            category: "Account"
        ),
        FAQItem(
            question: "Is my data secure?",
            answer: "Yes, we take data security seriously. All data is encrypted and stored securely. Read our Privacy Policy for more details.",
            category: "Privacy"
        ),
        FAQItem(
            question: "How do I change the app theme?",
            answer: "Go to Settings > Theme Settings to choose between light, dark, or system theme, and customize accent colors.",
            category: "Settings"
        )
    ]

    private var filteredFAQs: [FAQItem] {
        if searchText.isEmpty {
            return faqItems
        } else {
            return faqItems.filter { faq in
                faq.question.localizedCaseInsensitiveContains(searchText) ||
                faq.answer.localizedCaseInsensitiveContains(searchText) ||
                faq.category.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        List {
            Section {
                VStack(spacing: 16) {
                    Text("How can we help you?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        QuickActionCard(
                            icon: "message.circle",
                            title: "Live Chat",
                            subtitle: "Chat with support",
                            color: .blue
                        ) {
                            startLiveChat()
                        }

                        QuickActionCard(
                            icon: "envelope.circle",
                            title: "Email Us",
                            subtitle: "Send us an email",
                            color: .green
                        ) {
                            sendEmail()
                        }

                        QuickActionCard(
                            icon: "phone.circle",
                            title: "Call Support",
                            subtitle: "24/7 phone support",
                            color: .orange
                        ) {
                            callSupport()
                        }

                        QuickActionCard(
                            icon: "exclamationmark.triangle.circle",
                            title: "Report Bug",
                            subtitle: "Report an issue",
                            color: .red
                        ) {
                            reportBug()
                        }
                    }
                }
                .padding(.vertical)
            }

            Section {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.secondary)
                    TextField("Search for help...", text: $searchText)
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }

            Section(searchText.isEmpty ? "Frequently Asked Questions" : "Search Results (\(filteredFAQs.count))") {
                if filteredFAQs.isEmpty && !searchText.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 48))
                            .foregroundColor(.secondary)

                        VStack(spacing: 8) {
                            Text("No results found")
                                .font(.headline)

                            Text("Try different keywords or contact support")
                                .font(.body)
                                .foregroundColor(.secondary)
                        }

                        Button("Contact Support") {
                            showingContactSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
                } else {
                    ForEach(filteredFAQs, id: \.question) { faq in
                        FAQRowView(faq: faq)
                    }
                }
            }

            if searchText.isEmpty {
                Section("Additional Resources") {
                    ResourceRow(
                        icon: "book.circle",
                        title: "User Guide",
                        subtitle: "Complete app tutorial"
                    ) {
                        // Open user guide
                    }

                    ResourceRow(
                        icon: "video.circle",
                        title: "Video Tutorials",
                        subtitle: "Watch how-to videos"
                    ) {
                        // Open video tutorials
                    }

                    ResourceRow(
                        icon: "bubble.left.and.bubble.right.circle",
                        title: "Community Forum",
                        subtitle: "Connect with other users"
                    ) {
                        // Open community forum
                    }

                    ResourceRow(
                        icon: "sparkles.circle",
                        title: "What's New",
                        subtitle: "Latest app updates"
                    ) {
                        showWhatsNew()
                    }
                }

                Section("Still need help?") {
                    VStack(alignment: .leading, spacing: 12) {
                        ContactInfoRow(icon: "envelope", title: "Email", info: "support@awesomeapp.com")
                        ContactInfoRow(icon: "phone", title: "Phone", info: "+1 (555) 123-HELP")
                        ContactInfoRow(icon: "clock", title: "Hours", info: "Mon-Fri 9AM-6PM EST")

                        Button("Contact Support Team") {
                            showingContactSheet = true
                        }
                        .frame(maxWidth: .infinity)
                        .buttonStyle(.borderedProminent)
                        .padding(.top)
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle("Help & Support")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingContactSheet) {
            ContactSupportView()
        }
    }

    private func startLiveChat() {
        // Start live chat
    }

    private func sendEmail() {
        // Open email app
    }

    private func callSupport() {
        // Open phone dialer
    }

    private func reportBug() {
        // Navigate to bug report screen
    }

    private func showWhatsNew() {
        // Show what's new dialog
    }
}

struct FAQItem {
    let question: String
    let answer: String
    let category: String
}

struct QuickActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)

                VStack(spacing: 4) {
                    Text(title)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}

struct FAQRowView: View {
    let faq: FAQItem
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: { isExpanded.toggle() }) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(faq.question)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)

                        Text(faq.category)
                            .font(.caption)
                            .foregroundColor(.blue)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
            }
            .buttonStyle(.plain)

            if isExpanded {
                Text(faq.answer)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.top, 4)

                HStack {
                    Button("Helpful") {
                        // Mark as helpful
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)

                    Button("Not helpful") {
                        // Mark as not helpful
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)

                    Spacer()
                }
                .padding(.top, 8)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ResourceRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
                    .font(.caption)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ContactInfoRow: View {
    let icon: String
    let title: String
    let info: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 20)

            Text("\(title): ")
                .fontWeight(.medium)

            Text(info)
        }
        .font(.body)
    }
}

struct ContactSupportView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var message = ""

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Contact Support")
                    .font(.title2)
                    .fontWeight(.bold)

                TextField("Describe your issue...", text: $message, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(6...10)

                HStack {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)

                    Spacer()

                    Button("Send") {
                        // Send message
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(message.isEmpty)
                }

                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    NavigationView {
        HelpSupportScreen()
    }
}