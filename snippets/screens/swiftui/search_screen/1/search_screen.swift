import SwiftUI
import Combine

struct SearchScreen: View {
    @State private var searchText = ""
    @State private var recentSearches: [String] = []
    @State private var suggestions: [String] = []
    @State private var isLoading = false
    @FocusState private var isSearchFocused: Bool

    private let cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            TextField("Search for anything...", text: $searchText)
                                .focused($isSearchFocused)
                                .textFieldStyle(.plain)
                                .onSubmit {
                                    performSearch(searchText)
                                }

                            if !searchText.isEmpty {
                                Button {
                                    searchText = ""
                                    suggestions = []
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }

                    // Quick Filters
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            quickFilterButton("All", isSelected: true)
                            quickFilterButton("Images", isSelected: false)
                            quickFilterButton("Videos", isSelected: false)
                            quickFilterButton("Documents", isSelected: false)
                            quickFilterButton("Audio", isSelected: false)
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)

                // Content Area
                if searchText.isEmpty {
                    recentSearchesView
                } else {
                    suggestionsView
                }

                Spacer()
            }
            .navigationTitle("Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink("Advanced") {
                        AdvancedSearchScreen()
                    }
                }
            }
            .onAppear {
                loadRecentSearches()
                isSearchFocused = true
            }
            .onChange(of: searchText) { _, newValue in
                updateSuggestions(for: newValue)
            }
        }
    }

    private func quickFilterButton(_ title: String, isSelected: Bool) -> some View {
        Button(title) {
            // Handle filter selection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(isSelected ? Color.accentColor : Color(.systemGray6))
        .foregroundColor(isSelected ? .white : .primary)
        .cornerRadius(20)
    }

    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 0) {
            if recentSearches.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 64))
                        .foregroundColor(.gray)

                    Text("Start typing to search")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
                Spacer()
            } else {
                HStack {
                    Text("Recent Searches")
                        .font(.headline)
                        .padding(.horizontal)

                    Spacer()

                    Button("Clear All") {
                        recentSearches.removeAll()
                    }
                    .padding(.horizontal)
                }
                .padding(.top)

                List {
                    ForEach(recentSearches, id: \.self) { search in
                        HStack {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)

                            Text(search)

                            Spacer()

                            Button {
                                performSearch(search)
                            } label: {
                                Image(systemName: "arrow.up.right")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            searchText = search
                            isSearchFocused = true
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private var suggestionsView: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(suggestions, id: \.self) { suggestion in
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)

                            Text(suggestion)

                            Spacer()

                            Button {
                                searchText = suggestion
                                isSearchFocused = true
                            } label: {
                                Image(systemName: "arrow.up.left")
                                    .foregroundColor(.gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            performSearch(suggestion)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }

    private func loadRecentSearches() {
        // Load from UserDefaults in real app
        recentSearches = [
            "Swift programming",
            "iOS development",
            "SwiftUI tutorials",
            "Xcode tips",
        ]
    }

    private func updateSuggestions(for query: String) {
        guard !query.isEmpty else {
            suggestions = []
            return
        }

        isLoading = true

        // Simulate API call delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            suggestions = [
                "\(query) tutorial",
                "\(query) examples",
                "\(query) best practices",
                "\(query) documentation",
            ]
            isLoading = false
        }
    }

    private func performSearch(_ query: String) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        // Add to recent searches
        if let index = recentSearches.firstIndex(of: query) {
            recentSearches.remove(at: index)
        }
        recentSearches.insert(query, at: 0)
        if recentSearches.count > 10 {
            recentSearches.removeLast()
        }

        // Navigate to results screen
        // NavigationLink or programmatic navigation would go here
    }
}

struct AdvancedSearchScreen: View {
    var body: some View {
        Text("Advanced Search")
            .navigationTitle("Advanced Search")
    }
}

#Preview {
    SearchScreen()
}