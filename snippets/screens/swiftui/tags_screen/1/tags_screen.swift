import SwiftUI

struct Tag {
    let id: String
    let name: String
    let color: Color
    let count: Int
    let category: String
    let isPopular: Bool
}

struct TagsScreen: View {
    let selectedTags: [String]?

    @State private var allTags: [Tag] = []
    @State private var filteredTags: [Tag] = []
    @State private var selectedTagIds = Set<String>()
    @State private var selectedCategory = "all"
    @State private var sortBy = "popularity"
    @State private var searchText = ""
    @State private var isLoading = true
    @State private var currentTab = 0

    private let categories = [
        "all", "technology", "design", "business", "development",
        "marketing", "science", "education", "health", "lifestyle"
    ]

    @Environment(\.dismiss) private var dismiss

    init(selectedTags: [String]? = nil) {
        self.selectedTags = selectedTags
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    TextField("Search tags...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: searchText) { _, _ in
                            filterTags()
                        }

                    if !searchText.isEmpty {
                        Button {
                            searchText = ""
                            filterTags()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)

                // Filters and Sort
                HStack(spacing: 12) {
                    // Category Filter
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category == "all" ? "All Categories" : category.capitalized)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedCategory) { _, _ in
                        filterTags()
                    }

                    Spacer()

                    // Sort Picker
                    Picker("Sort", selection: $sortBy) {
                        Text("Most Popular").tag("popularity")
                        Text("A-Z").tag("alphabetical")
                        Text("Recently Added").tag("recent")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: sortBy) { _, _ in
                        sortTags()
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)

                // Tab View
                TabView(selection: $currentTab) {
                    browseTab
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Browse")
                        }
                        .tag(0)

                    popularTab
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                            Text("Popular")
                        }
                        .tag(1)

                    myTagsTab
                        .tabItem {
                            Image(systemName: "bookmark.fill")
                            Text("My Tags")
                        }
                        .tag(2)
                }
            }
            .navigationTitle("Tags (\(selectedTagIds.count) selected)")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !selectedTagIds.isEmpty {
                        Button("Apply") {
                            applyTags()
                        }
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .onAppear {
            loadTags()
        }
        .safeAreaInset(edge: .bottom) {
            if !selectedTagIds.isEmpty {
                bottomActionBar
            }
        }
    }

    private var browseTab: some View {
        Group {
            if isLoading {
                VStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            } else if filteredTags.isEmpty {
                emptyStateView
            } else {
                ScrollView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
                        ForEach(filteredTags, id: \.id) { tag in
                            tagCard(tag)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var popularTab: some View {
        let popularTags = allTags.filter { $0.isPopular }.sorted { $0.count > $1.count }

        return List {
            ForEach(popularTags.indices, id: \.self) { index in
                let tag = popularTags[index]
                tagListItem(tag, rank: index + 1)
            }
        }
        .listStyle(.plain)
    }

    private var myTagsTab: some View {
        let myTags = allTags.filter { selectedTagIds.contains($0.id) }

        return Group {
            if myTags.isEmpty {
                VStack(spacing: 16) {
                    Spacer()

                    Image(systemName: "bookmark")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)

                    Text("No tags selected")
                        .font(.title2)
                        .fontWeight(.bold)

                    Text("Browse tags and add them to your collection")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    Button("Browse Tags") {
                        currentTab = 0
                    }
                    .buttonStyle(.borderedProminent)

                    Spacer()
                }
                .padding()
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(myTags, id: \.id) { tag in
                            selectedTagChip(tag)
                        }
                    }
                    .padding()
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            Text("No tags found")
                .font(.title2)
                .fontWeight(.bold)

            Text("Try adjusting your search or filters")
                .font(.body)
                .foregroundColor(.secondary)

            Spacer()
        }
    }

    private var bottomActionBar: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 16) {
                Button("Clear All") {
                    selectedTagIds.removeAll()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.systemGray6))
                .foregroundColor(.primary)
                .cornerRadius(10)

                Button("Apply \(selectedTagIds.count) Tags") {
                    applyTags()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .fontWeight(.semibold)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
        }
        .background(Color(.systemBackground))
    }

    private func tagCard(_ tag: Tag) -> some View {
        let isSelected = selectedTagIds.contains(tag.id)

        return Button {
            toggleTag(tag.id)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(tag.color)
                        .frame(width: 12, height: 12)

                    Text(tag.name)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? tag.color : .primary)
                        .lineLimit(1)

                    Spacer()

                    if isSelected {
                        Image(systemName: "checkmark")
                            .foregroundColor(tag.color)
                            .font(.caption)
                    }
                }

                Text("\(tag.count) items")
                    .font(.caption)
                    .foregroundColor(isSelected ? tag.color.opacity(0.7) : .secondary)
            }
            .padding()
            .background(isSelected ? tag.color.opacity(0.1) : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? tag.color : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(.plain)
    }

    private func tagListItem(_ tag: Tag, rank: Int) -> some View {
        let isSelected = selectedTagIds.contains(tag.id)

        return HStack {
            Circle()
                .fill(tag.color.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay {
                    Text("\(rank)")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(tag.color)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(tag.name)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(isSelected ? tag.color : .primary)

                Text("\(tag.count) items • \(tag.category.uppercased())")
                    .font(.caption)
                    .foregroundColor(isSelected ? tag.color.opacity(0.7) : .secondary)
            }

            Spacer()

            if tag.isPopular {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .foregroundColor(.orange)
                    .font(.caption)
            }

            Button {
                toggleTag(tag.id)
            } label: {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? tag.color : .gray)
            }
            .buttonStyle(.plain)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleTag(tag.id)
        }
    }

    private func selectedTagChip(_ tag: Tag) -> some View {
        HStack {
            Circle()
                .fill(Color.white.opacity(0.3))
                .frame(width: 20, height: 20)
                .overlay {
                    Text(tag.count > 1000 ? "\(tag.count / 1000)k" : "\(tag.count)")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }

            Text(tag.name)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.white)

            Spacer()

            Button {
                toggleTag(tag.id)
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.caption)
            }
        }
        .padding()
        .background(tag.color)
        .cornerRadius(12)
    }

    private func loadTags() {
        isLoading = true

        // Simulate loading tags
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            allTags = generateMockTags()
            filteredTags = allTags

            // Load initial selected tags
            if let selectedTags = selectedTags {
                selectedTagIds = Set(allTags.filter { selectedTags.contains($0.name) }.map { $0.id })
            }

            isLoading = false
        }
    }

    private func generateMockTags() -> [Tag] {
        let tagData: [(String, String, Color, Int)] = [
            ("Flutter", "technology", .blue, 2450),
            ("SwiftUI", "technology", .blue, 1820),
            ("React", "technology", .cyan, 3200),
            ("JavaScript", "technology", .yellow, 4150),
            ("Python", "technology", .green, 3850),
            ("UI Design", "design", .red, 2100),
            ("UX Research", "design", .red, 1550),
            ("Figma", "design", .orange, 1890),
            ("Adobe XD", "design", .purple, 920),
            ("Prototyping", "design", .red, 1340),
            ("Startup", "business", .mint, 2800),
            ("Entrepreneurship", "business", .mint, 1950),
            ("Marketing", "business", .mint, 2350),
            ("SEO", "marketing", .indigo, 1780),
            ("Content Marketing", "marketing", .indigo, 1420),
            ("Social Media", "marketing", .indigo, 2680),
            ("Machine Learning", "science", .green, 3100),
            ("Data Science", "science", .green, 2750),
            ("AI", "science", .green, 3450),
            ("Blockchain", "technology", .yellow, 1650),
            ("Cryptocurrency", "technology", .yellow, 1890),
            ("Web Development", "development", .pink, 3800),
            ("Mobile Development", "development", .pink, 2650),
            ("DevOps", "development", .pink, 1950),
            ("Cloud Computing", "technology", .blue, 2450),
            ("AWS", "technology", .orange, 1780),
            ("Docker", "development", .blue, 1650),
            ("Kubernetes", "development", .blue, 1420),
            ("Photography", "lifestyle", .pink, 1890),
            ("Travel", "lifestyle", .yellow, 2340),
        ]

        return tagData.enumerated().map { index, data in
            Tag(
                id: "tag_\(index)",
                name: data.0,
                color: data.2,
                count: data.3,
                category: data.1,
                isPopular: data.3 > 2000
            )
        }
    }

    private func filterTags() {
        filteredTags = allTags.filter { tag in
            let matchesSearch = searchText.isEmpty || tag.name.localizedCaseInsensitiveContains(searchText)
            let matchesCategory = selectedCategory == "all" || tag.category == selectedCategory
            return matchesSearch && matchesCategory
        }

        sortTags()
    }

    private func sortTags() {
        switch sortBy {
        case "alphabetical":
            filteredTags.sort { $0.name < $1.name }
        case "popularity":
            filteredTags.sort { $0.count > $1.count }
        case "recent":
            // In a real app, you'd sort by creation/update time
            filteredTags.sort { $0.count > $1.count }
        default:
            break
        }
    }

    private func toggleTag(_ tagId: String) {
        if selectedTagIds.contains(tagId) {
            selectedTagIds.remove(tagId)
        } else {
            selectedTagIds.insert(tagId)
        }
    }

    private func applyTags() {
        let selectedTagNames = allTags
            .filter { selectedTagIds.contains($0.id) }
            .map { $0.name }

        // Return selected tag names to parent view
        dismiss()
    }
}

#Preview {
    TagsScreen()
}