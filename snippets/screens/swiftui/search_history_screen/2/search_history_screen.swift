import SwiftUI

struct SearchHistoryItem {
    let id: String
    let query: String
    let timestamp: Date
    let resultCount: Int
    let category: String?
    let filters: [String]
}

struct SearchHistoryScreen: View {
    @State private var searchHistory: [SearchHistoryItem] = []
    @State private var filteredHistory: [SearchHistoryItem] = []
    @State private var searchText = ""
    @State private var isLoading = true
    @State private var selectedTimeFilter = "all"
    @State private var isSelectionMode = false
    @State private var selectedItems = Set<String>()

    private let timeFilters = [
        ("all", "All time"),
        ("today", "Today"),
        ("week", "This week"),
        ("month", "This month")
    ]

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    TextField("Search in history...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: searchText) { _, _ in
                            filterHistory()
                        }

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            filterHistory()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)

                // Time Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(timeFilters, id: \.0) { filter in
                            timeFilterChip(filter.1, value: filter.0)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Content
                if isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if filteredHistory.isEmpty {
                    emptyStateView
                } else {
                    historyList
                }
            }
            .navigationTitle(isSelectionMode ? "\(selectedItems.count) selected" : "Search History")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if isSelectionMode {
                        Button("Cancel") {
                            isSelectionMode = false
                            selectedItems.removeAll()
                        }
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    if isSelectionMode {
                        if !selectedItems.isEmpty {
                            Button {
                                deleteSelectedItems()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    } else {
                        Button {
                            isSelectionMode = true
                        } label: {
                            Image(systemName: "checkmark.circle")
                        }

                        Menu {
                            Button("Clear All History", role: .destructive) {
                                clearAllHistory()
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
        }
        .onAppear {
            loadSearchHistory()
        }
    }

    private func timeFilterChip(_ label: String, value: String) -> some View {
        let isSelected = selectedTimeFilter == value

        return Button {
            selectedTimeFilter = value
            filterHistory()
        } label: {
            Text(label)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "clock")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            Text(searchText.isEmpty ? "No search history" : "No matching searches found")
                .font(.title2)
                .fontWeight(.bold)

            Text(searchText.isEmpty ? "Your recent searches will appear here" : "Try different keywords")
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()
        }
    }

    private var historyList: some View {
        List {
            ForEach(groupedHistory.keys.sorted { groupOrder($0) < groupOrder($1) }, id: \.self) { group in
                Section {
                    ForEach(groupedHistory[group] ?? [], id: \.id) { item in
                        historyItem(item)
                    }
                } header: {
                    Text(group)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                }
            }
        }
        .listStyle(.plain)
    }

    private var groupedHistory: [String: [SearchHistoryItem]] {
        let calendar = Calendar.current
        let now = Date()

        return Dictionary(grouping: filteredHistory) { item in
            if calendar.isDateInToday(item.timestamp) {
                return "Today"
            } else if calendar.isDateInYesterday(item.timestamp) {
                return "Yesterday"
            } else if item.timestamp > calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now {
                return "This week"
            } else if item.timestamp > calendar.date(byAdding: .month, value: -1, to: now) ?? now {
                return "This month"
            } else {
                return "Older"
            }
        }
    }

    private func groupOrder(_ group: String) -> Int {
        switch group {
        case "Today": return 0
        case "Yesterday": return 1
        case "This week": return 2
        case "This month": return 3
        case "Older": return 4
        default: return 5
        }
    }

    private func historyItem(_ item: SearchHistoryItem) -> some View {
        HStack {
            if isSelectionMode {
                Button {
                    toggleItemSelection(item.id)
                } label: {
                    Image(systemName: selectedItems.contains(item.id) ? "checkmark.circle.fill" : "circle")
                        .foregroundColor(selectedItems.contains(item.id) ? .accentColor : .gray)
                }
                .buttonStyle(.plain)
            } else {
                Image(systemName: "clock")
                    .foregroundColor(.accentColor)
                    .frame(width: 24)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(item.query)
                    .font(.body)
                    .fontWeight(.medium)

                HStack(spacing: 8) {
                    Text(relativeTime(from: item.timestamp))
                        .font(.caption)
                        .foregroundColor(.secondary)

                    if let category = item.category {
                        Text(category)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(4)
                    }

                    ForEach(item.filters, id: \.self) { filter in
                        Text(filter)
                            .font(.caption)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color(.systemGray5))
                            .foregroundColor(.secondary)
                            .cornerRadius(4)
                    }
                }
            }

            Spacer()

            if !isSelectionMode {
                Menu {
                    Button {
                        UIPasteboard.general.string = item.query
                    } label: {
                        Label("Copy", systemImage: "doc.on.clipboard")
                    }

                    Button("Delete", role: .destructive) {
                        deleteHistoryItem(item.id)
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            if isSelectionMode {
                toggleItemSelection(item.id)
            } else {
                performSearch(item.query)
            }
        }
    }

    private func loadSearchHistory() {
        isLoading = true

        // Simulate loading from storage
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            searchHistory = generateMockHistory()
            filteredHistory = searchHistory
            isLoading = false
        }
    }

    private func generateMockHistory() -> [SearchHistoryItem] {
        let queries = [
            "Swift programming",
            "iOS development",
            "SwiftUI tutorials",
            "Xcode tips",
            "Core Data",
            "Combine framework",
            "App Store optimization",
            "TestFlight beta",
            "Apple HIG",
            "Performance optimization",
            "Memory management",
            "Auto Layout",
            "Dark mode",
            "Accessibility",
            "Push notifications"
        ]

        let categories = ["Development", "Design", "Testing", "Distribution"]

        return queries.enumerated().map { index, query in
            let daysAgo = index * 2 + (index % 3)
            return SearchHistoryItem(
                id: "search_\(index)",
                query: query,
                timestamp: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date(),
                resultCount: 50 + (index * 15),
                category: categories[index % categories.count],
                filters: index % 3 == 0 ? ["iOS", "Popular"] : index % 4 == 0 ? ["Recent", "Trending"] : []
            )
        }
    }

    private func filterHistory() {
        filteredHistory = searchHistory.filter { item in
            let matchesSearch = searchText.isEmpty || item.query.localizedCaseInsensitiveContains(searchText)
            let matchesTimeFilter = matchesTimeFilter(item)
            return matchesSearch && matchesTimeFilter
        }
    }

    private func matchesTimeFilter(_ item: SearchHistoryItem) -> Bool {
        let calendar = Calendar.current
        let now = Date()

        switch selectedTimeFilter {
        case "today":
            return calendar.isDateInToday(item.timestamp)
        case "week":
            return item.timestamp > calendar.date(byAdding: .weekOfYear, value: -1, to: now) ?? now
        case "month":
            return item.timestamp > calendar.date(byAdding: .month, value: -1, to: now) ?? now
        default:
            return true
        }
    }

    private func performSearch(_ query: String) {
        // Navigate to search results with query
        // This would typically use NavigationLink or programmatic navigation
    }

    private func deleteHistoryItem(_ id: String) {
        searchHistory.removeAll { $0.id == id }
        filteredHistory.removeAll { $0.id == id }
        // In a real app, you would also remove from persistent storage
    }

    private func deleteSelectedItems() {
        searchHistory.removeAll { selectedItems.contains($0.id) }
        filteredHistory.removeAll { selectedItems.contains($0.id) }
        selectedItems.removeAll()
        isSelectionMode = false
        // In a real app, you would also remove from persistent storage
    }

    private func clearAllHistory() {
        searchHistory.removeAll()
        filteredHistory.removeAll()
        // In a real app, you would also clear persistent storage
    }

    private func toggleItemSelection(_ id: String) {
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }

    private func relativeTime(from date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: date, to: now)

        if let weeks = components.weekOfYear, weeks > 0 {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            return formatter.string(from: date)
        } else if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else {
            return "Just now"
        }
    }
}

#Preview {
    SearchHistoryScreen()
}