import SwiftUI

struct SearchResult {
    let id: String
    let title: String
    let description: String
    let imageUrl: String?
    let price: Double?
    let rating: Double?
    let reviewCount: Int?
    let category: String?
    let tags: [String]
    let dateAdded: Date?
    let author: String?
    let source: String?
}

struct SearchResultsScreen: View {
    let query: String?
    let filters: [String: Any]?

    @State private var searchText: String
    @State private var results: [SearchResult] = []
    @State private var isLoading = false
    @State private var isLoadingMore = false
    @State private var hasMoreResults = true
    @State private var currentFilters: [String: Any] = [:]
    @State private var sortBy = "relevance"
    @State private var isGridView = false
    @State private var showFilterSheet = false
    @State private var showSortSheet = false

    @State private var totalResults = 0
    @State private var currentPage = 1
    private let pageSize = 20

    init(query: String? = nil, filters: [String: Any]? = nil) {
        self.query = query
        self.filters = filters
        self._searchText = State(initialValue: query ?? "")
        self._currentFilters = State(initialValue: filters ?? [:])
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                HStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            performSearch()
                        }

                    Button {
                        isGridView.toggle()
                    } label: {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                    }

                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                .padding(.horizontal)

                // Search Summary and Controls
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(isLoading ? "Searching..." : "About \(totalResults) results for \"\(searchText)\"")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Spacer()

                        Button {
                            showSortSheet = true
                        } label: {
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.arrow.down")
                                    .font(.caption)
                                Text(sortBy.uppercased())
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                        }
                        .foregroundColor(.accentColor)
                    }

                    // Active Filters
                    if !activeFilters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(activeFilters, id: \.key) { filter in
                                    filterChip(filter.key, value: filter.value) {
                                        removeFilter(filter.key, value: filter.value)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))

                // Results
                if isLoading && results.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if results.isEmpty {
                    emptyStateView
                } else {
                    if isGridView {
                        gridView
                    } else {
                        listView
                    }
                }
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            performSearch()
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterScreen(initialFilters: currentFilters)
        }
        .sheet(isPresented: $showSortSheet) {
            SortScreen()
        }
    }

    private var activeFilters: [(key: String, value: String)] {
        var filters: [(key: String, value: String)] = []

        currentFilters.forEach { key, value in
            if let stringValue = value as? String, !stringValue.isEmpty {
                filters.append((key: key, value: stringValue))
            } else if let arrayValue = value as? [String], !arrayValue.isEmpty {
                arrayValue.forEach { item in
                    filters.append((key: key, value: item))
                }
            }
        }

        return filters
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()

            Image(systemName: "magnifyingglass.circle")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            Text("No results found")
                .font(.title2)
                .fontWeight(.bold)

            Text("Try adjusting your search or filters")
                .font(.body)
                .foregroundColor(.secondary)

            Button("Clear Filters") {
                currentFilters.removeAll()
                performSearch()
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
    }

    private var listView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(results, id: \.id) { result in
                    resultListItem(result)
                }

                if hasMoreResults {
                    ProgressView()
                        .onAppear {
                            loadMoreResults()
                        }
                }
            }
            .padding()
        }
    }

    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 2), spacing: 16) {
                ForEach(results, id: \.id) { result in
                    resultGridItem(result)
                }

                if hasMoreResults {
                    GridRow {
                        ProgressView()
                            .gridCellColumns(2)
                            .onAppear {
                                loadMoreResults()
                            }
                    }
                }
            }
            .padding()
        }
    }

    private func resultListItem(_ result: SearchResult) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Image
            AsyncImage(url: URL(string: result.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 8) {
                // Title
                Text(highlightedText(result.title, query: searchText))
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)

                // Description
                Text(result.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)

                // Metadata
                HStack {
                    if let rating = result.rating {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                        }
                    }

                    if let category = result.category {
                        Text(category)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor.opacity(0.1))
                            .foregroundColor(.accentColor)
                            .cornerRadius(4)
                    }

                    Spacer()

                    if let price = result.price {
                        Text("$\(String(format: "%.2f", price))")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }

    private func resultGridItem(_ result: SearchResult) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image
            AsyncImage(url: URL(string: result.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray6))
                    .overlay {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
            }
            .frame(height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(highlightedText(result.title, query: searchText))
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .lineLimit(2)

                HStack {
                    if let rating = result.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                            Text(String(format: "%.1f", rating))
                                .font(.caption2)
                        }
                    }

                    Spacer()

                    if let price = result.price {
                        Text("$\(Int(price))")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.accentColor)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
    }

    private func filterChip(_ key: String, value: String, onRemove: @escaping () -> Void) -> some View {
        HStack(spacing: 4) {
            Text("\(key): \(value)")
                .font(.caption)

            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark")
                    .font(.caption2)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(12)
    }

    private func highlightedText(_ text: String, query: String) -> AttributedString {
        var attributedString = AttributedString(text)

        if !query.isEmpty {
            let ranges = text.ranges(of: query, options: .caseInsensitive)
            for range in ranges {
                let startIndex = attributedString.characters.index(
                    attributedString.startIndex,
                    offsetBy: text.distance(from: text.startIndex, to: range.lowerBound)
                )
                let endIndex = attributedString.characters.index(
                    attributedString.startIndex,
                    offsetBy: text.distance(from: text.startIndex, to: range.upperBound)
                )

                attributedString[startIndex..<endIndex].foregroundColor = .accentColor
                attributedString[startIndex..<endIndex].font = .bold
            }
        }

        return attributedString
    }

    private func performSearch(isNewSearch: Bool = true) {
        if isNewSearch {
            results.removeAll()
            currentPage = 1
            isLoading = true
            hasMoreResults = true
        }

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let newResults = generateMockResults()
            if isNewSearch {
                results = newResults
                totalResults = 157 // Mock total
            } else {
                results.append(contentsOf: newResults)
            }
            isLoading = false
            isLoadingMore = false
            hasMoreResults = results.count < totalResults
        }
    }

    private func loadMoreResults() {
        guard !isLoadingMore && hasMoreResults else { return }

        isLoadingMore = true
        currentPage += 1
        performSearch(isNewSearch: false)
    }

    private func generateMockResults() -> [SearchResult] {
        return (0..<20).map { index in
            let baseIndex = (currentPage - 1) * pageSize + index
            return SearchResult(
                id: "result_\(baseIndex)",
                title: "Search Result \(baseIndex + 1) - \(searchText)",
                description: "This is a detailed description for search result \(baseIndex + 1). It contains relevant information about \(searchText) and provides useful context for the user.",
                imageUrl: "https://picsum.photos/300/200?random=\(baseIndex)",
                price: (baseIndex % 5 == 0) ? 29.99 + Double(baseIndex) * 2.5 : nil,
                rating: 3.0 + Double(baseIndex % 3),
                reviewCount: 50 + (baseIndex * 12),
                category: ["Electronics", "Books", "Clothing", "Home"][baseIndex % 4],
                tags: ["Popular", "New", "Featured"],
                dateAdded: Date().addingTimeInterval(-Double(baseIndex) * 86400),
                author: "Author \(baseIndex % 10)",
                source: "Source \(baseIndex % 5)"
            )
        }
    }

    private func removeFilter(_ key: String, value: String) {
        if var array = currentFilters[key] as? [String] {
            array.removeAll { $0 == value }
            if array.isEmpty {
                currentFilters.removeValue(forKey: key)
            } else {
                currentFilters[key] = array
            }
        } else {
            currentFilters.removeValue(forKey: key)
        }
        performSearch()
    }
}

// Helper extension for string ranges
extension String {
    func ranges(of substring: String, options: CompareOptions = []) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        var start = startIndex

        while let range = range(of: substring, options: options, range: start..<endIndex) {
            ranges.append(range)
            start = range.upperBound
        }

        return ranges
    }
}

#Preview {
    SearchResultsScreen(query: "Swift programming")
}