import SwiftUI
import Combine

struct Article: Identifiable, Codable {
    let id = UUID()
    let title: String
    let summary: String
    let imageURL: String
    let author: String
    let publishDate: Date
    let readTime: Int
    let tags: [String]
    var isBookmarked: Bool = false
}

struct ArticleListView: View {
    @StateObject private var viewModel = ArticleListViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var showBookmarks = false

    let categories = ["All", "Technology", "Business", "Sports", "Health", "Entertainment"]

    var filteredArticles: [Article] {
        viewModel.articles.filter { article in
            let matchesSearch = searchText.isEmpty ||
                article.title.localizedCaseInsensitiveContains(searchText) ||
                article.summary.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == "All" ||
                article.tags.contains(selectedCategory.lowercased())

            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                SearchBar(text: $searchText)

                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryChip(
                                title: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                // Articles List
                if viewModel.isLoading {
                    ProgressView("Loading articles...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredArticles.isEmpty {
                    EmptyStateView(
                        title: "No articles found",
                        subtitle: "Try adjusting your search or filters",
                        systemImage: "doc.text"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredArticles) { article in
                                NavigationLink(
                                    destination: ArticleDetailView(article: article)
                                ) {
                                    ArticleRowView(
                                        article: article,
                                        onBookmarkTap: {
                                            viewModel.toggleBookmark(article)
                                        }
                                    )
                                }
                                .buttonStyle(PlainButtonStyle())
                            }

                            if viewModel.hasMoreArticles {
                                ProgressView()
                                    .onAppear {
                                        viewModel.loadMoreArticles()
                                    }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .refreshable {
                        await viewModel.refreshArticles()
                    }
                }
            }
            .navigationTitle("Articles")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            showBookmarks.toggle()
                        } label: {
                            Label("Bookmarks", systemImage: "bookmark")
                        }

                        Button {
                            viewModel.sortByDate()
                        } label: {
                            Label("Sort by Date", systemImage: "calendar")
                        }

                        Button {
                            viewModel.sortByPopularity()
                        } label: {
                            Label("Sort by Popularity", systemImage: "heart.fill")
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .task {
            await viewModel.loadArticles()
        }
        .sheet(isPresented: $showBookmarks) {
            BookmarkView()
        }
    }
}

struct ArticleRowView: View {
    let article: Article
    let onBookmarkTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Article Image
            AsyncImage(url: URL(string: article.imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    .clipped()
                    .cornerRadius(12)
            } placeholder: {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title)
                    )
            }

            // Article Content
            VStack(alignment: .leading, spacing: 8) {
                // Tags
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(article.tags, id: \.self) { tag in
                            Text(tag.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.blue.opacity(0.1))
                                .foregroundColor(.blue)
                                .cornerRadius(8)
                        }
                    }
                }

                // Title
                Text(article.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                // Summary
                Text(article.summary)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)

                // Metadata
                HStack {
                    // Author
                    HStack(spacing: 4) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 24, height: 24)
                            .overlay(
                                Text(String(article.author.prefix(1)))
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )

                        Text(article.author)
                            .font(.caption)
                            .fontWeight(.medium)
                    }

                    Spacer()

                    // Read Time
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text("\(article.readTime) min read")
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)

                    // Bookmark Button
                    Button(action: onBookmarkTap) {
                        Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.system(size: 16))
                            .foregroundColor(article.isBookmarked ? .blue : .gray)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                // Publish Date
                Text(article.publishDate, style: .relative)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct CategoryChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false

    var body: some View {
        HStack {
            TextField("Search articles...", text: $text)
                .padding(.leading, 24)
                .onTapGesture {
                    isEditing = true
                }

            if isEditing && !text.isEmpty {
                Button("Clear") {
                    text = ""
                }
                .foregroundColor(.blue)
                .padding(.trailing, 8)
            }
        }
        .padding(.vertical, 10)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
        .overlay(
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                Spacer()
            }
        )
        .padding(.horizontal)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            isEditing = false
        }
    }
}

struct EmptyStateView: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: systemImage)
                .font(.system(size: 64))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)

                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

@MainActor
class ArticleListViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var hasMoreArticles = true

    private var currentPage = 1
    private let pageSize = 20

    func loadArticles() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newArticles = generateSampleArticles(page: currentPage)
        articles = newArticles
        currentPage = 2
    }

    func loadMoreArticles() {
        Task {
            await loadMoreArticlesAsync()
        }
    }

    private func loadMoreArticlesAsync() async {
        guard !isLoading && hasMoreArticles else { return }

        isLoading = true
        defer { isLoading = false }

        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)

        let newArticles = generateSampleArticles(page: currentPage)
        articles.append(contentsOf: newArticles)
        currentPage += 1

        if currentPage > 5 {
            hasMoreArticles = false
        }
    }

    func refreshArticles() async {
        currentPage = 1
        hasMoreArticles = true
        await loadArticles()
    }

    func toggleBookmark(_ article: Article) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isBookmarked.toggle()
        }
    }

    func sortByDate() {
        articles.sort { $0.publishDate > $1.publishDate }
    }

    func sortByPopularity() {
        articles.sort { $0.readTime < $1.readTime } // Assuming shorter read time = more popular
    }

    private func generateSampleArticles(page: Int) -> [Article] {
        let titles = [
            "The Future of Artificial Intelligence in Healthcare",
            "Climate Change: What We Can Do Today",
            "Breaking: Major Tech Company Announces Revolutionary Product",
            "The Rise of Remote Work: Challenges and Opportunities",
            "Space Exploration: Humanity's Next Frontier",
            "Sustainable Energy Solutions for Tomorrow",
            "The Impact of Social Media on Mental Health",
            "Cryptocurrency: Understanding the Digital Economy",
            "Machine Learning Transforms Medical Diagnosis",
            "The Evolution of Electric Vehicles"
        ]

        let authors = ["Dr. Sarah Johnson", "Michael Chen", "Emma Rodriguez", "Prof. David Kim", "Lisa Thompson"]
        let tags = [
            ["technology", "ai", "healthcare"],
            ["environment", "climate", "sustainability"],
            ["business", "technology", "innovation"],
            ["workplace", "productivity", "lifestyle"],
            ["space", "exploration", "science"],
            ["energy", "environment", "technology"],
            ["health", "social media", "psychology"],
            ["finance", "cryptocurrency", "technology"],
            ["healthcare", "ai", "innovation"],
            ["automotive", "technology", "environment"]
        ]

        return (0..<pageSize).compactMap { index in
            let globalIndex = (page - 1) * pageSize + index
            guard globalIndex < titles.count * 3 else { return nil }

            let titleIndex = globalIndex % titles.count

            return Article(
                title: titles[titleIndex],
                summary: "This comprehensive article explores the latest developments and insights in \(titles[titleIndex].lowercased()), providing readers with expert analysis and actionable information.",
                imageURL: "https://picsum.photos/400/250?random=\(globalIndex)",
                author: authors[globalIndex % authors.count],
                publishDate: Date().addingTimeInterval(-Double(globalIndex * 3600 * 24)),
                readTime: 3 + (globalIndex % 8),
                tags: tags[titleIndex]
            )
        }
    }
}