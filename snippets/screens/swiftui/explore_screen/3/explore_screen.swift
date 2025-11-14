import SwiftUI

struct ExploreScreen: View {
    @StateObject private var viewModel = ExploreViewModel()
    @State private var searchText = ""
    @State private var selectedTab = 0

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search bar
                SearchBar(text: $searchText, onSubmit: {
                    viewModel.performSearch(searchText)
                })
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                // Tab picker
                Picker("Explore", selection: $selectedTab) {
                    Text("Trending").tag(0)
                    Text("Tags").tag(1)
                    Text("People").tag(2)
                    Text("Places").tag(3)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 16)
                .padding(.bottom, 12)

                // Content
                TabView(selection: $selectedTab) {
                    TrendingView(viewModel: viewModel)
                        .tag(0)

                    TagsView(viewModel: viewModel)
                        .tag(1)

                    PeopleView(viewModel: viewModel)
                        .tag(2)

                    PlacesView(viewModel: viewModel)
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            viewModel.loadExploreContent()
        }
    }
}

struct TrendingView: View {
    @ObservedObject var viewModel: ExploreViewModel

    let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Category filters
                CategoryFilterView(
                    selectedCategory: $viewModel.selectedCategory,
                    categories: viewModel.categories
                )

                // Featured trending section
                FeaturedTrendingCard()
                    .padding(.horizontal, 16)

                // Posts grid
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(viewModel.filteredPosts) { post in
                        TrendingPostCard(post: post) {
                            viewModel.viewPost(post)
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .refreshable {
            await viewModel.refreshTrending()
        }
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: String
    let categories: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    FilterChip(
                        title: category,
                        isSelected: selectedCategory == category,
                        onTap: {
                            selectedCategory = category
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct FeaturedTrendingCard: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: [.purple, .blue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(height: 120)
            .overlay(
                VStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .font(.system(size: 32))
                        .foregroundColor(.white)

                    Text("Trending Now")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            )
    }
}

struct TrendingPostCard: View {
    let post: ExplorePost
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                AsyncImage(url: URL(string: post.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Image(systemName: "photo")
                                .foregroundColor(.gray)
                        )
                }
                .clipped()

                // Video indicator
                if post.isVideo {
                    VStack {
                        HStack {
                            Spacer()
                            HStack(spacing: 2) {
                                Image(systemName: "play.fill")
                                    .font(.caption2)
                                Text(post.duration ?? "")
                                    .font(.caption2)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(4)
                            .padding(8)
                        }
                        Spacer()
                    }
                }

                // Like count overlay
                VStack {
                    Spacer()
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                            Text(formatCount(post.likes))
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(4)
                        .padding(8)

                        Spacer()
                    }
                }
            }
        }
        .buttonStyle(.plain)
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct TagsView: View {
    @ObservedObject var viewModel: ExploreViewModel

    let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.trendingTags, id: \.self) { tag in
                    TagCard(tag: tag) {
                        viewModel.searchByTag(tag)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct TagCard: View {
    let tag: String
    let onTap: () -> Void

    private var postCount: Int {
        abs(tag.hashCode) % 1000000
    }

    private var gradientColors: [Color] {
        switch tag.lowercased() {
        case "#trending":
            return [.orange, .red]
        case "#photography":
            return [.blue, .purple]
        case "#travel":
            return [.teal, .blue]
        case "#food":
            return [.orange, .red]
        case "#fashion":
            return [.pink, .purple]
        case "#fitness":
            return [.green, .teal]
        case "#art":
            return [.purple, .pink]
        case "#nature":
            return [.green, .mint]
        default:
            return [.gray, .secondary]
        }
    }

    var body: some View {
        Button(action: onTap) {
            RoundedRectangle(cornerRadius: 12)
                .fill(
                    LinearGradient(
                        colors: gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 120)
                .overlay(
                    VStack(alignment: .leading) {
                        Text(tag)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)

                        Spacer()

                        Text("\(formatCount(postCount)) posts")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                )
        }
        .buttonStyle(.plain)
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct PeopleView: View {
    @ObservedObject var viewModel: ExploreViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.suggestedUsers) { user in
                    SuggestedUserCard(user: user) {
                        viewModel.followUser(user)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct SuggestedUserCard: View {
    let user: SuggestedUser
    let onFollow: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: user.avatar)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.3))
            }
            .frame(width: 60, height: 60)
            .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(user.username)
                        .font(.headline)
                        .fontWeight(.semibold)

                    if user.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                }

                Text(user.displayName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("\(formatCount(user.followersCount)) followers")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Follow") {
                onFollow()
            }
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.blue)
            .cornerRadius(8)
        }
        .padding(.all, 16)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func formatCount(_ count: Int) -> String {
        if count < 1000 { return "\(count)" }
        if count < 1000000 { return String(format: "%.1fK", Double(count) / 1000) }
        return String(format: "%.1fM", Double(count) / 1000000)
    }
}

struct PlacesView: View {
    @ObservedObject var viewModel: ExploreViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.places, id: \.name) { place in
                    PlaceCard(place: place) {
                        viewModel.searchByPlace(place.name)
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

struct PlaceCard: View {
    let place: Place
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                AsyncImage(url: URL(string: place.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                }
                .frame(height: 120)
                .clipped()
                .cornerRadius(12)

                // Gradient overlay
                LinearGradient(
                    colors: [.clear, .black.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .cornerRadius(12)

                // Text overlay
                VStack(alignment: .leading) {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(place.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.white)

                            Text(place.posts)
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
        .buttonStyle(.plain)
    }
}

@MainActor
class ExploreViewModel: ObservableObject {
    @Published var posts: [ExplorePost] = []
    @Published var filteredPosts: [ExplorePost] = []
    @Published var selectedCategory = "All"
    @Published var trendingTags: [String] = []
    @Published var suggestedUsers: [SuggestedUser] = []
    @Published var places: [Place] = []

    let categories = ["All", "Photos", "Videos", "People", "Tags"]

    func loadExploreContent() {
        loadPosts()
        loadTags()
        loadUsers()
        loadPlaces()
    }

    private func loadPosts() {
        posts = [
            ExplorePost(
                id: "1",
                imageUrl: "https://example.com/trending1.jpg",
                likes: 2456,
                comments: 123,
                username: "travel_photographer",
                isVideo: false,
                tags: ["travel", "landscape", "sunset"]
            ),
            ExplorePost(
                id: "2",
                imageUrl: "https://example.com/trending2.jpg",
                likes: 1834,
                comments: 89,
                username: "food_lover",
                isVideo: true,
                duration: "0:45",
                tags: ["food", "recipe", "cooking"]
            ),
            ExplorePost(
                id: "3",
                imageUrl: "https://example.com/trending3.jpg",
                likes: 3021,
                comments: 234,
                username: "street_artist",
                isVideo: false,
                tags: ["art", "street", "graffiti"]
            )
        ]

        filteredPosts = posts
    }

    private func loadTags() {
        trendingTags = [
            "#trending",
            "#photography",
            "#travel",
            "#food",
            "#fashion",
            "#fitness",
            "#art",
            "#nature",
            "#lifestyle",
            "#music",
            "#dance",
            "#comedy"
        ]
    }

    private func loadUsers() {
        suggestedUsers = [
            SuggestedUser(
                username: "amazing_photographer",
                displayName: "Alex Chen",
                avatar: "https://example.com/suggested1.jpg",
                isVerified: true,
                followersCount: 125000
            ),
            SuggestedUser(
                username: "chef_master",
                displayName: "Maria Rodriguez",
                avatar: "https://example.com/suggested2.jpg",
                isVerified: false,
                followersCount: 85000
            ),
            SuggestedUser(
                username: "fitness_coach",
                displayName: "John Smith",
                avatar: "https://example.com/suggested3.jpg",
                isVerified: true,
                followersCount: 200000
            )
        ]
    }

    private func loadPlaces() {
        places = [
            Place(
                name: "New York City",
                posts: "2.3M posts",
                image: "https://example.com/nyc.jpg"
            ),
            Place(
                name: "Tokyo",
                posts: "1.8M posts",
                image: "https://example.com/tokyo.jpg"
            ),
            Place(
                name: "Paris",
                posts: "1.5M posts",
                image: "https://example.com/paris.jpg"
            ),
            Place(
                name: "London",
                posts: "1.2M posts",
                image: "https://example.com/london.jpg"
            )
        ]
    }

    func performSearch(_ query: String) {
        // Navigate to search results
    }

    func searchByTag(_ tag: String) {
        // Navigate to search results for tag
    }

    func searchByPlace(_ place: String) {
        // Navigate to search results for place
    }

    func viewPost(_ post: ExplorePost) {
        // Navigate to post detail
    }

    func followUser(_ user: SuggestedUser) {
        // Follow user
    }

    func refreshTrending() async {
        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        posts.shuffle()
        filteredPosts = posts
    }
}

struct ExplorePost: Identifiable {
    let id: String
    let imageUrl: String
    let likes: Int
    let comments: Int
    let username: String
    let isVideo: Bool
    let duration: String?
    let tags: [String]

    init(id: String, imageUrl: String, likes: Int, comments: Int, username: String, isVideo: Bool, duration: String? = nil, tags: [String]) {
        self.id = id
        self.imageUrl = imageUrl
        self.likes = likes
        self.comments = comments
        self.username = username
        self.isVideo = isVideo
        self.duration = duration
        self.tags = tags
    }
}

struct SuggestedUser: Identifiable {
    let id = UUID()
    let username: String
    let displayName: String
    let avatar: String
    let isVerified: Bool
    let followersCount: Int
}

struct Place {
    let name: String
    let posts: String
    let image: String
}

extension String {
    var hashCode: Int {
        var hasher = Hasher()
        hasher.combine(self)
        return hasher.finalize()
    }
}

#Preview {
    ExploreScreen()
}