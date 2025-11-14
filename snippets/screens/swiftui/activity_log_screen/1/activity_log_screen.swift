import SwiftUI

struct ActivityLogScreen: View {
    @State private var selectedFilter = "All"
    @State private var selectedUser = "All Users"
    @State private var searchText = ""
    @State private var showingFilters = false
    @State private var showingSearch = false
    @State private var activities = sampleActivities

    private let filters = ["All", "Purchase", "Account", "Payment", "Profile", "Security", "Review", "System", "Support"]
    private let users = ["All Users", "John Smith", "Sarah Wilson", "Mike Johnson", "Emma Davis", "Alex Rodriguez", "Admin", "System"]

    var body: some View {
        VStack(spacing: 0) {
            summaryCards
                .padding()

            activeFilters

            activityList
        }
        .navigationTitle("Activity Log")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: { showingFilters = true }) {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }

                Button(action: { showingSearch = true }) {
                    Image(systemName: "magnifyingglass")
                }

                Menu {
                    Button("Export Log", action: exportLog)
                    Button("Clear History", action: clearHistory)
                    Button("Log Settings", action: showSettings)
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingFilters) {
            FiltersView(
                selectedFilter: $selectedFilter,
                selectedUser: $selectedUser,
                filters: filters,
                users: users
            )
        }
        .sheet(isPresented: $showingSearch) {
            SearchView(searchText: $searchText)
        }
        .refreshable {
            await refreshActivities()
        }
    }

    private var summaryCards: some View {
        HStack(spacing: 12) {
            SummaryCard(
                title: "Total Activities",
                value: "\(activities.count)",
                icon: "list.bullet.clipboard",
                color: .blue
            )

            SummaryCard(
                title: "Critical",
                value: "\(activities.filter { $0.severity == .error }.count)",
                icon: "exclamationmark.triangle.fill",
                color: .red
            )

            SummaryCard(
                title: "Recent (1h)",
                value: "\(activities.filter { Calendar.current.isDate($0.timestamp, equalTo: Date(), toGranularity: .hour) }.count)",
                icon: "clock.fill",
                color: .green
            )
        }
    }

    @ViewBuilder
    private var activeFilters: some View {
        let hasActiveFilters = selectedFilter != "All" || selectedUser != "All Users" || !searchText.isEmpty

        if hasActiveFilters {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Active Filters:")
                        .font(.caption)
                        .fontWeight(.bold)

                    Spacer()

                    Button("Clear All") {
                        selectedFilter = "All"
                        selectedUser = "All Users"
                        searchText = ""
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        if selectedFilter != "All" {
                            FilterChip(text: "Type: \(selectedFilter)") {
                                selectedFilter = "All"
                            }
                        }

                        if selectedUser != "All Users" {
                            FilterChip(text: "User: \(selectedUser)") {
                                selectedUser = "All Users"
                            }
                        }

                        if !searchText.isEmpty {
                            FilterChip(text: "Search: \(searchText)") {
                                searchText = ""
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }

    private var activityList: some View {
        List(filteredActivities, id: \.id) { activity in
            ActivityCard(activity: activity) {
                showActivityDetails(activity)
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(PlainListStyle())
        .overlay {
            if filteredActivities.isEmpty {
                EmptyStateView()
            }
        }
    }

    private var filteredActivities: [ActivityLogEntry] {
        activities.filter { activity in
            let typeMatch = selectedFilter == "All" || activity.type.rawValue.lowercased() == selectedFilter.lowercased()
            let userMatch = selectedUser == "All Users" || activity.user == selectedUser
            let searchMatch = searchText.isEmpty ||
                             activity.action.localizedCaseInsensitiveContains(searchText) ||
                             activity.details.localizedCaseInsensitiveContains(searchText) ||
                             activity.user.localizedCaseInsensitiveContains(searchText)

            return typeMatch && userMatch && searchMatch
        }
    }

    private func showActivityDetails(_ activity: ActivityLogEntry) {
        // Show activity details
    }

    private func exportLog() {
        // Export functionality
    }

    private func clearHistory() {
        // Clear history functionality
    }

    private func showSettings() {
        // Show settings
    }

    private func refreshActivities() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }

    private static let sampleActivities: [ActivityLogEntry] = [
        ActivityLogEntry(
            id: "1",
            user: "John Smith",
            action: "Completed purchase",
            details: "Order #12345 - iPhone 14 Pro",
            timestamp: Date().addingTimeInterval(-300),
            type: .purchase,
            severity: .info,
            metadata: ["amount": "$999.99", "orderId": "12345"]
        ),
        ActivityLogEntry(
            id: "2",
            user: "Sarah Wilson",
            action: "User registration",
            details: "New account created with email verification",
            timestamp: Date().addingTimeInterval(-900),
            type: .account,
            severity: .success,
            metadata: ["email": "sarah.wilson@email.com"]
        ),
        ActivityLogEntry(
            id: "3",
            user: "System",
            action: "Failed payment attempt",
            details: "Credit card declined for order #12344",
            timestamp: Date().addingTimeInterval(-1800),
            type: .payment,
            severity: .error,
            metadata: ["orderId": "12344", "reason": "Insufficient funds"]
        ),
        ActivityLogEntry(
            id: "4",
            user: "Mike Johnson",
            action: "Profile updated",
            details: "Changed shipping address and phone number",
            timestamp: Date().addingTimeInterval(-3600),
            type: .profile,
            severity: .info,
            metadata: ["fields": "address, phone"]
        ),
        ActivityLogEntry(
            id: "5",
            user: "Admin",
            action: "Security alert",
            details: "Multiple failed login attempts detected",
            timestamp: Date().addingTimeInterval(-7200),
            type: .security,
            severity: .warning,
            metadata: ["attempts": "5", "ip": "192.168.1.100"]
        ),
        ActivityLogEntry(
            id: "6",
            user: "Emma Davis",
            action: "Product review",
            details: "Left 5-star review for Wireless Headphones",
            timestamp: Date().addingTimeInterval(-10800),
            type: .review,
            severity: .success,
            metadata: ["rating": "5", "productId": "WH001"]
        ),
        ActivityLogEntry(
            id: "7",
            user: "System",
            action: "Data backup completed",
            details: "Automated daily backup finished successfully",
            timestamp: Date().addingTimeInterval(-14400),
            type: .system,
            severity: .success,
            metadata: ["size": "2.3GB", "duration": "45min"]
        ),
        ActivityLogEntry(
            id: "8",
            user: "Alex Rodriguez",
            action: "Support ticket created",
            details: "Issue with order delivery tracking",
            timestamp: Date().addingTimeInterval(-18000),
            type: .support,
            severity: .warning,
            metadata: ["ticketId": "SUP-456", "priority": "Medium"]
        )
    ]
}

struct SummaryCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(12)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }
}

struct FilterChip: View {
    let text: String
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.caption)

            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
            }
        }
        .foregroundColor(.blue)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ActivityCard: View {
    let activity: ActivityLogEntry
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: 12) {
                // Activity icon
                Image(systemName: getActivityIcon())
                    .font(.system(size: 16))
                    .foregroundColor(getActivityColor())
                    .frame(width: 32, height: 32)
                    .background(getActivityColor().opacity(0.1))
                    .cornerRadius(8)

                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(activity.action)
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        Spacer()

                        SeverityBadge(severity: activity.severity)
                    }

                    Text(activity.details)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)

                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(activity.user)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()

                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text(formatTimestamp(activity.timestamp))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    if !activity.metadata.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 4) {
                                ForEach(Array(activity.metadata.prefix(3)), id: \.key) { key, value in
                                    MetadataChip(key: key, value: value)
                                }
                            }
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.1), radius: 8, x: 0, y: 2)
    }

    private func getActivityIcon() -> String {
        switch activity.type {
        case .purchase: return "cart.fill"
        case .account: return "person.circle.fill"
        case .payment: return "creditcard.fill"
        case .profile: return "pencil.circle.fill"
        case .security: return "shield.fill"
        case .review: return "star.fill"
        case .system: return "gear.circle.fill"
        case .support: return "questionmark.circle.fill"
        }
    }

    private func getActivityColor() -> Color {
        switch activity.type {
        case .purchase: return .green
        case .account: return .blue
        case .payment: return .orange
        case .profile: return .purple
        case .security: return .red
        case .review: return .yellow
        case .system: return .gray
        case .support: return .cyan
        }
    }

    private func formatTimestamp(_ timestamp: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(timestamp)

        if interval < 60 {
            return "Just now"
        } else if interval < 3600 {
            return "\(Int(interval / 60))m ago"
        } else if interval < 86400 {
            return "\(Int(interval / 3600))h ago"
        } else if interval < 604800 {
            return "\(Int(interval / 86400))d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: timestamp)
        }
    }
}

struct SeverityBadge: View {
    let severity: ActivitySeverity

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: getIcon())
                .font(.system(size: 10))

            Text(severity.rawValue)
                .font(.caption)
                .fontWeight(.medium)
        }
        .foregroundColor(getColor())
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(getColor().opacity(0.1))
        .cornerRadius(6)
    }

    private func getIcon() -> String {
        switch severity {
        case .info: return "info.circle.fill"
        case .success: return "checkmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .error: return "xmark.circle.fill"
        }
    }

    private func getColor() -> Color {
        switch severity {
        case .info: return .blue
        case .success: return .green
        case .warning: return .orange
        case .error: return .red
        }
    }
}

struct MetadataChip: View {
    let key: String
    let value: String

    var body: some View {
        Text("\(key): \(value)")
            .font(.system(size: 10))
            .foregroundColor(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color(.systemGray6))
            .cornerRadius(4)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "clock")
                .font(.system(size: 64))
                .foregroundColor(.secondary)

            Text("No activities found")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text("Try adjusting your filters or check back later")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct FiltersView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedFilter: String
    @Binding var selectedUser: String
    let filters: [String]
    let users: [String]
    @State private var startDate: Date?
    @State private var endDate: Date?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Activity Type")
                        .font(.headline)

                    Picker("Filter", selection: $selectedFilter) {
                        ForEach(filters, id: \.self) { filter in
                            Text(filter)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("User")
                        .font(.headline)

                    Picker("User", selection: $selectedUser) {
                        ForEach(users, id: \.self) { user in
                            Text(user)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Date Range")
                        .font(.headline)

                    HStack {
                        DatePicker("Start", selection: Binding(
                            get: { startDate ?? Date() },
                            set: { startDate = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()

                        Text("to")

                        DatePicker("End", selection: Binding(
                            get: { endDate ?? Date() },
                            set: { endDate = $0 }
                        ), displayedComponents: .date)
                        .labelsHidden()
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Filter Activities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        selectedFilter = "All"
                        selectedUser = "All Users"
                        startDate = nil
                        endDate = nil
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var searchText: String
    @FocusState private var isSearchFocused: Bool

    private let quickSearches = ["Failed payments", "New registrations", "Security alerts", "System errors"]

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Search by action, details, or user...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($isSearchFocused)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Quick Searches:")
                        .font(.headline)

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(quickSearches, id: \.self) { query in
                            Button(query) {
                                searchText = query
                                dismiss()
                            }
                            .font(.body)
                            .foregroundColor(.blue)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Search Activities")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Search") {
                        dismiss()
                    }
                    .disabled(searchText.isEmpty)
                }
            }
            .onAppear {
                isSearchFocused = true
            }
        }
    }
}

// Data models
struct ActivityLogEntry {
    let id: String
    let user: String
    let action: String
    let details: String
    let timestamp: Date
    let type: ActivityType
    let severity: ActivitySeverity
    let metadata: [String: String]
}

enum ActivityType: String, CaseIterable {
    case purchase = "Purchase"
    case account = "Account"
    case payment = "Payment"
    case profile = "Profile"
    case security = "Security"
    case review = "Review"
    case system = "System"
    case support = "Support"
}

enum ActivitySeverity: String, CaseIterable {
    case info = "Info"
    case success = "Success"
    case warning = "Warning"
    case error = "Error"
}

#Preview {
    NavigationView {
        ActivityLogScreen()
    }
}