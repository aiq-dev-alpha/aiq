import SwiftUI

struct VideoItem: Identifiable {
    let id = UUID()
    let title: String
    let thumbnailURL: String
    let duration: TimeInterval
    let author: String
    let authorAvatarURL: String
    let views: Int
    let uploadDate: Date
    let category: String
    let isLive: Bool
}

struct VideoListView: View {
    @StateObject private var viewModel = VideoListViewModel()
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var isGridView = false
    @State private var showFilters = false

    let categories = ["All", "Trending", "Music", "Gaming", "Sports", "News", "Technology", "Education"]

    var filteredVideos: [VideoItem] {
        viewModel.videos.filter { video in
            let matchesSearch = searchText.isEmpty ||
                video.title.localizedCaseInsensitiveContains(searchText) ||
                video.author.localizedCaseInsensitiveContains(searchText)

            let matchesCategory = selectedCategory == "All" ||
                video.category == selectedCategory ||
                (selectedCategory == "Trending" && video.views > 100000)

            return matchesSearch && matchesCategory
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)

                // Category Tabs
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            CategoryTab(
                                title: category,
                                isSelected: selectedCategory == category
                            ) {
                                selectedCategory = category
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Video List/Grid
                if viewModel.isLoading && viewModel.videos.isEmpty {
                    ProgressView("Loading videos...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if filteredVideos.isEmpty {
                    EmptyVideoState()
                } else {
                    if isGridView {
                        VideoGridView(videos: filteredVideos, viewModel: viewModel)
                    } else {
                        VideoListScrollView(videos: filteredVideos, viewModel: viewModel)
                    }
                }
            }
            .navigationTitle("Videos")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isGridView.toggle()
                    } label: {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                    }

                    Button {
                        showFilters = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        // Profile or menu action
                    } label: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Text("U")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }
                }
            }
        }
        .task {
            await viewModel.loadVideos()
        }
        .refreshable {
            await viewModel.refreshVideos()
        }
        .sheet(isPresented: $showFilters) {
            VideoFiltersSheet(
                selectedCategory: $selectedCategory,
                categories: categories
            )
        }
    }
}

struct VideoListScrollView: View {
    let videos: [VideoItem]
    @ObservedObject var viewModel: VideoListViewModel

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(videos) { video in
                    NavigationLink(
                        destination: VideoPlayerView(
                            video: VideoData(
                                title: video.title,
                                description: "An engaging video about \(video.category.lowercased()) that provides valuable insights and entertainment.",
                                videoURL: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
                                thumbnailURL: video.thumbnailURL,
                                duration: video.duration,
                                author: video.author,
                                views: video.views,
                                uploadDate: video.uploadDate
                            )
                        )
                    ) {
                        VideoRowView(
                            video: video,
                            onMoreTap: {
                                viewModel.showVideoOptions(video)
                            }
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if viewModel.hasMoreVideos {
                    ProgressView()
                        .onAppear {
                            viewModel.loadMoreVideos()
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct VideoGridView: View {
    let videos: [VideoItem]
    @ObservedObject var viewModel: VideoListViewModel

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(videos) { video in
                    NavigationLink(
                        destination: VideoPlayerView(
                            video: VideoData(
                                title: video.title,
                                description: "An engaging video about \(video.category.lowercased()).",
                                videoURL: "https://sample-videos.com/zip/10/mp4/SampleVideo_1280x720_1mb.mp4",
                                thumbnailURL: video.thumbnailURL,
                                duration: video.duration,
                                author: video.author,
                                views: video.views,
                                uploadDate: video.uploadDate
                            )
                        )
                    ) {
                        VideoGridItemView(video: video)
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                if viewModel.hasMoreVideos {
                    ProgressView()
                        .gridCellColumns(2)
                        .onAppear {
                            viewModel.loadMoreVideos()
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct VideoRowView: View {
    let video: VideoItem
    let onMoreTap: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Thumbnail
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 68)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 120, height: 68)
                        .overlay(
                            Image(systemName: "play.circle")
                                .font(.title)
                                .foregroundColor(.white)
                        )
                }

                // Duration badge
                if !video.isLive {
                    Text(formatDuration(video.duration))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(4)
                        .padding(4)
                }

                // Live badge
                if video.isLive {
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                        .padding(4)
                }
            }

            // Video Info
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: video.authorAvatarURL)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .clipped()
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 20, height: 20)
                            .overlay(
                                Text(String(video.author.prefix(1)))
                                    .font(.caption2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }

                    Text(video.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Text("\(formatViews(video.views)) views • \(formatUploadDate(video.uploadDate))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            // More button
            Button(action: onMoreTap) {
                Image(systemName: "ellipsis")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 4)
    }
}

struct VideoGridItemView: View {
    let video: VideoItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Thumbnail
            ZStack(alignment: .bottomTrailing) {
                AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                        .clipped()
                        .cornerRadius(8)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.3))
                        .aspectRatio(16/9, contentMode: .fit)
                        .overlay(
                            Image(systemName: "play.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                        )
                }

                // Duration or Live badge
                if video.isLive {
                    Text("LIVE")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .cornerRadius(4)
                        .padding(4)
                } else {
                    Text(formatDuration(video.duration))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.black.opacity(0.8))
                        .cornerRadius(4)
                        .padding(4)
                }
            }

            // Video Info
            VStack(alignment: .leading, spacing: 4) {
                Text(video.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                HStack(spacing: 6) {
                    AsyncImage(url: URL(string: video.authorAvatarURL)) { image in
                        image
                            .resizable()
                            .frame(width: 16, height: 16)
                            .clipShape(Circle())
                    } placeholder: {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 16, height: 16)
                            .overlay(
                                Text(String(video.author.prefix(1)))
                                    .font(.system(size: 8))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                            )
                    }

                    Text(video.author)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }

                Text("\(formatViews(video.views)) views")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CategoryTab: View {
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
                    Capsule()
                        .fill(isSelected ? Color.primary : Color.gray.opacity(0.2))
                )
                .foregroundColor(isSelected ? Color(UIColor.systemBackground) : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptyVideoState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "play.rectangle")
                .font(.system(size: 64))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text("No videos found")
                    .font(.headline)
                    .fontWeight(.semibold)

                Text("Try adjusting your search or filters")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

struct VideoFiltersSheet: View {
    @Binding var selectedCategory: String
    let categories: [String]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                Section("Category") {
                    ForEach(categories, id: \.self) { category in
                        HStack {
                            Text(category)
                            Spacer()
                            if category == selectedCategory {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCategory = category
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

@MainActor
class VideoListViewModel: ObservableObject {
    @Published var videos: [VideoItem] = []
    @Published var isLoading = false
    @Published var hasMoreVideos = true

    private var currentPage = 1
    private let pageSize = 20

    func loadVideos() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        // Simulate API call
        try? await Task.sleep(nanoseconds: 1_000_000_000)

        let newVideos = generateSampleVideos(page: currentPage)
        videos = newVideos
        currentPage = 2
    }

    func loadMoreVideos() {
        Task {
            await loadMoreVideosAsync()
        }
    }

    private func loadMoreVideosAsync() async {
        guard !isLoading && hasMoreVideos else { return }

        isLoading = true
        defer { isLoading = false }

        // Simulate API call
        try? await Task.sleep(nanoseconds: 500_000_000)

        let newVideos = generateSampleVideos(page: currentPage)
        videos.append(contentsOf: newVideos)
        currentPage += 1

        if currentPage > 5 {
            hasMoreVideos = false
        }
    }

    func refreshVideos() async {
        currentPage = 1
        hasMoreVideos = true
        await loadVideos()
    }

    func showVideoOptions(_ video: VideoItem) {
        // Show video options
    }

    private func generateSampleVideos(page: Int) -> [VideoItem] {
        let titles = [
            "Amazing Technology Demo - You Won't Believe What Happens Next!",
            "Top 10 Programming Tips for Beginners",
            "Live Coding Session: Building a Mobile App",
            "Flutter Development Tutorial - Complete Guide",
            "Mobile App Design Principles You Need to Know",
            "Advanced Animation Techniques in iOS",
            "State Management Best Practices",
            "Performance Optimization Guide",
            "UI/UX Design Trends 2024",
            "Building Scalable Applications"
        ]

        let authors = ["TechGuru", "CodeMaster", "DevChannel", "AppAcademy", "DigitalCreator"]
        let categories = ["Technology", "Education", "Entertainment", "News", "Sports"]

        return (0..<pageSize).compactMap { index in
            let globalIndex = (page - 1) * pageSize + index
            guard globalIndex < titles.count * 3 else { return nil }

            let titleIndex = globalIndex % titles.count

            return VideoItem(
                title: titles[titleIndex],
                thumbnailURL: "https://picsum.photos/320/180?random=\(globalIndex)",
                duration: TimeInterval(120 + (globalIndex % 600)), // 2-12 minutes
                author: authors[globalIndex % authors.count],
                authorAvatarURL: "https://i.pravatar.cc/100?img=\(globalIndex % 50)",
                views: (globalIndex + 1) * 1000 + (globalIndex * 123),
                uploadDate: Date().addingTimeInterval(-Double(globalIndex * 3600 * 24)),
                category: categories[globalIndex % categories.count],
                isLive: globalIndex % 15 == 0
            )
        }
    }
}

// Helper functions
func formatDuration(_ duration: TimeInterval) -> String {
    let minutes = Int(duration) / 60
    let seconds = Int(duration) % 60
    return String(format: "%d:%02d", minutes, seconds)
}

func formatViews(_ views: Int) -> String {
    if views >= 1_000_000 {
        return String(format: "%.1fM", Double(views) / 1_000_000)
    } else if views >= 1_000 {
        return String(format: "%.1fK", Double(views) / 1_000)
    } else {
        return "\(views)"
    }
}

func formatUploadDate(_ date: Date) -> String {
    let now = Date()
    let components = Calendar.current.dateComponents([.day, .hour, .minute], from: date, to: now)

    if let days = components.day, days > 0 {
        if days == 1 {
            return "1 day ago"
        } else if days < 7 {
            return "\(days) days ago"
        } else if days < 30 {
            let weeks = days / 7
            return "\(weeks) week\(weeks == 1 ? "" : "s") ago"
        } else if days < 365 {
            let months = days / 30
            return "\(months) month\(months == 1 ? "" : "s") ago"
        } else {
            let years = days / 365
            return "\(years) year\(years == 1 ? "" : "s") ago"
        }
    } else if let hours = components.hour, hours > 0 {
        return "\(hours) hour\(hours == 1 ? "" : "s") ago"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
    } else {
        return "Just now"
    }
}