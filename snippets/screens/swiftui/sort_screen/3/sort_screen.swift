import SwiftUI

enum SortOption: String, CaseIterable {
    case relevance = "relevance"
    case priceLowToHigh = "price_low"
    case priceHighToLow = "price_high"
    case rating = "rating"
    case newest = "newest"
    case oldest = "oldest"
    case popularity = "popularity"
    case alphabetical = "alphabetical"
    case reverseAlphabetical = "reverse_alphabetical"
    case distance = "distance"
    case mostViewed = "most_viewed"
    case mostDownloaded = "most_downloaded"

    var title: String {
        switch self {
        case .relevance: return "Relevance"
        case .priceLowToHigh: return "Price: Low to High"
        case .priceHighToLow: return "Price: High to Low"
        case .rating: return "Rating"
        case .newest: return "Date Added"
        case .oldest: return "Date Added"
        case .popularity: return "Popularity"
        case .alphabetical: return "Name"
        case .reverseAlphabetical: return "Name"
        case .distance: return "Distance"
        case .mostViewed: return "Most Viewed"
        case .mostDownloaded: return "Most Downloaded"
        }
    }

    var subtitle: String {
        switch self {
        case .relevance: return "Most relevant results first"
        case .priceLowToHigh: return "Cheapest items first"
        case .priceHighToLow: return "Most expensive items first"
        case .rating: return "Highest rated items first"
        case .newest: return "Most recently added"
        case .oldest: return "Oldest items first"
        case .popularity: return "Most popular items first"
        case .alphabetical: return "A to Z order"
        case .reverseAlphabetical: return "Z to A order"
        case .distance: return "Nearest locations first"
        case .mostViewed: return "Highest view count first"
        case .mostDownloaded: return "Highest download count first"
        }
    }

    var icon: String {
        switch self {
        case .relevance: return "star"
        case .priceLowToHigh: return "arrow.up"
        case .priceHighToLow: return "arrow.down"
        case .rating: return "star.fill"
        case .newest, .oldest: return "clock"
        case .popularity: return "chart.line.uptrend.xyaxis"
        case .alphabetical, .reverseAlphabetical: return "textformat.abc"
        case .distance: return "location"
        case .mostViewed: return "eye"
        case .mostDownloaded: return "arrow.down.circle"
        }
    }

    var hasDirection: Bool {
        switch self {
        case .relevance, .priceLowToHigh, .priceHighToLow:
            return false
        default:
            return true
        }
    }
}

struct SortScreen: View {
    let currentSort: SortOption?

    @State private var selectedSort: SortOption
    @State private var ascending = true

    @Environment(\.dismiss) private var dismiss

    init(currentSort: SortOption? = nil) {
        self.currentSort = currentSort
        self._selectedSort = State(initialValue: currentSort ?? .relevance)
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Current Selection Summary
                if selectedSort != .relevance {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Current Sort")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(getSortTitle(selectedSort, ascending: ascending))
                            .font(.headline)
                            .fontWeight(.bold)

                        Text(getSortSubtitle(selectedSort, ascending: ascending))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.accentColor.opacity(0.1))
                }

                ScrollView {
                    LazyVStack(spacing: 0) {
                        // Quick Sort Options
                        sectionHeader("Quick Sort")

                        Group {
                            sortTile(.relevance)
                            sortTile(.priceLowToHigh)
                            sortTile(.priceHighToLow)
                            sortTile(.rating)
                        }

                        Divider()
                            .padding(.vertical, 16)

                        // Date & Popularity
                        sectionHeader("Date & Popularity")

                        Group {
                            sortTile(.newest)
                            sortTile(.popularity)
                            sortTile(.mostViewed)
                            sortTile(.mostDownloaded)
                        }

                        Divider()
                            .padding(.vertical, 16)

                        // Other Options
                        sectionHeader("Other Options")

                        Group {
                            sortTile(.alphabetical)
                            sortTile(.distance)
                        }

                        // Sort Direction Control
                        if selectedSort.hasDirection {
                            Divider()
                                .padding(.vertical, 16)

                            sectionHeader("Sort Direction")

                            VStack(spacing: 0) {
                                directionTile(
                                    title: "Ascending",
                                    subtitle: getSortSubtitle(selectedSort, ascending: true),
                                    isSelected: ascending
                                ) {
                                    ascending = true
                                }

                                Divider()
                                    .padding(.leading, 60)

                                directionTile(
                                    title: "Descending",
                                    subtitle: getSortSubtitle(selectedSort, ascending: false),
                                    isSelected: !ascending
                                ) {
                                    ascending = false
                                }
                            }
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }

                        // Space for apply button
                        Color.clear.frame(height: 120)
                    }
                }

                // Bottom Actions
                VStack(spacing: 0) {
                    Divider()

                    HStack(spacing: 16) {
                        Button("Reset") {
                            selectedSort = .relevance
                            ascending = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(.systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(10)

                        Button("Apply Sort") {
                            applySort()
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
            .navigationTitle("Sort Options")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Apply") {
                        applySort()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func sortTile(_ option: SortOption) -> some View {
        let isSelected = selectedSort == option

        return Button {
            selectedSort = option
            // Reset to default direction when changing sort type
            switch option {
            case .newest, .rating, .popularity, .mostViewed, .mostDownloaded:
                ascending = false // Default to descending for these
            case .alphabetical, .distance:
                ascending = true // Default to ascending for these
            default:
                break
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: option.icon)
                    .font(.title3)
                    .foregroundColor(isSelected ? .accentColor : .secondary)
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 4) {
                    Text(getSortTitle(option, ascending: ascending))
                        .font(.body)
                        .fontWeight(isSelected ? .semibold : .regular)
                        .foregroundColor(isSelected ? .accentColor : .primary)

                    Text(getSortSubtitle(option, ascending: ascending))
                        .font(.caption)
                        .foregroundColor(isSelected ? .accentColor.opacity(0.7) : .secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                }
            }
            .padding()
            .background(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            .cornerRadius(10)
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
    }

    private func directionTile(title: String, subtitle: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .fontWeight(isSelected ? .semibold : .regular)

                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .buttonStyle(.plain)
        .foregroundColor(.primary)
    }

    private func getSortTitle(_ option: SortOption, ascending: Bool) -> String {
        if !option.hasDirection { return option.title }

        switch option {
        case .rating:
            return ascending ? "Rating: Low to High" : "Rating: High to Low"
        case .newest:
            return ascending ? "Date: Oldest First" : "Date: Newest First"
        case .popularity:
            return ascending ? "Popularity: Low to High" : "Popularity: High to Low"
        case .alphabetical:
            return ascending ? "Name: A to Z" : "Name: Z to A"
        case .distance:
            return ascending ? "Distance: Near to Far" : "Distance: Far to Near"
        case .mostViewed:
            return ascending ? "Views: Low to High" : "Views: High to Low"
        case .mostDownloaded:
            return ascending ? "Downloads: Low to High" : "Downloads: High to Low"
        default:
            return option.title
        }
    }

    private func getSortSubtitle(_ option: SortOption, ascending: Bool) -> String {
        if !option.hasDirection { return option.subtitle }

        switch option {
        case .rating:
            return ascending ? "Lowest rated first" : "Highest rated first"
        case .newest:
            return ascending ? "Oldest items first" : "Newest items first"
        case .popularity:
            return ascending ? "Least popular first" : "Most popular first"
        case .alphabetical:
            return ascending ? "A to Z order" : "Z to A order"
        case .distance:
            return ascending ? "Closest locations first" : "Farthest locations first"
        case .mostViewed:
            return ascending ? "Lowest views first" : "Highest views first"
        case .mostDownloaded:
            return ascending ? "Lowest downloads first" : "Highest downloads first"
        default:
            return option.subtitle
        }
    }

    private func applySort() {
        let result: [String: Any] = [
            "sortOption": selectedSort.rawValue,
            "ascending": ascending
        ]

        // Return sort configuration to parent view
        dismiss()
    }
}

#Preview {
    SortScreen()
}