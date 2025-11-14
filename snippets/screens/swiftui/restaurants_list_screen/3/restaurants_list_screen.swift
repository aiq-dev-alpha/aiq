import SwiftUI

struct RestaurantsListScreen: View {
    @State private var searchText = ""
    @State private var selectedSort = "Rating"
    @State private var showingFilter = false

    let restaurants = [
        Restaurant(id: "1", name: "The Golden Spoon", cuisine: "Italian", rating: 4.8, reviewCount: 324, priceRange: .expensive, deliveryTime: "25-40 min", deliveryFee: 3.99, distance: 0.8, isOpen: true, isFeatured: true, address: "123 Main St, Downtown"),
        Restaurant(id: "2", name: "Sakura Sushi", cuisine: "Japanese", rating: 4.6, reviewCount: 198, priceRange: .moderate, deliveryTime: "30-45 min", deliveryFee: 2.99, distance: 1.2, isOpen: true, isFeatured: false, address: "456 Oak Ave, Midtown"),
        Restaurant(id: "3", name: "Taco Libre", cuisine: "Mexican", rating: 4.4, reviewCount: 256, priceRange: .budget, deliveryTime: "15-30 min", deliveryFee: 1.99, distance: 0.5, isOpen: true, isFeatured: true, address: "789 Pine St, Eastside"),
        Restaurant(id: "4", name: "Le Petit Bistro", cuisine: "French", rating: 4.9, reviewCount: 412, priceRange: .expensive, deliveryTime: "35-50 min", deliveryFee: 4.99, distance: 2.1, isOpen: false, isFeatured: false, address: "321 Elm Dr, Westside")
    ]

    var filteredRestaurants: [Restaurant] {
        var filtered = restaurants

        if !searchText.isEmpty {
            filtered = filtered.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.cuisine.localizedCaseInsensitiveContains(searchText)
            }
        }

        filtered = filtered.sorted { first, second in
            if first.isFeatured && !second.isFeatured { return true }
            if !first.isFeatured && second.isFeatured { return false }
            if first.isOpen && !second.isOpen { return true }
            if !first.isOpen && second.isOpen { return false }

            switch selectedSort {
            case "Rating": return first.rating > second.rating
            case "Distance": return first.distance < second.distance
            case "Price": return first.priceRange.rawValue < second.priceRange.rawValue
            default: return first.rating > second.rating
            }
        }

        return filtered
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Filter Chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SortChip(selectedSort: $selectedSort, title: "Sort: \(selectedSort)")

                        FilterChip(title: "Italian", isSelected: false) { }
                        FilterChip(title: "Fast Food", isSelected: false) { }
                        FilterChip(title: "Open Now", isSelected: false) { }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                if filteredRestaurants.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "fork.knife.circle")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No restaurants found")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Try adjusting your search or filters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    // Restaurants List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredRestaurants) { restaurant in
                                NavigationLink(destination: RestaurantDetailScreen(restaurant: restaurant)) {
                                    RestaurantCard(restaurant: restaurant)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Restaurants")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        // Show map view
                    } label: {
                        Image(systemName: "map")
                    }

                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterSheet()
            }
        }
    }
}

struct RestaurantCard: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Restaurant Header
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(restaurant.cuisineColor.gradient)
                    .frame(height: 200)

                // Badges
                VStack(alignment: .leading, spacing: 6) {
                    if restaurant.isFeatured {
                        Text("Featured")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    if !restaurant.isOpen {
                        Text("Closed")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(12)

                // Distance badge (top right)
                HStack {
                    Spacer()
                    Text("\(restaurant.distance, specifier: "%.1f") km")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.7))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(12)
                }
            }

            // Restaurant Info
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(restaurant.name)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Text(restaurant.priceRange.displayText)
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(restaurant.priceRange.color.opacity(0.1))
                        .foregroundColor(restaurant.priceRange.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }

                Text(restaurant.cuisine)
                    .font(.subheadline)
                    .foregroundColor(restaurant.cuisineColor)
                    .fontWeight(.semibold)

                HStack {
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)

                        Text(String(format: "%.1f", restaurant.rating))
                            .font(.caption)
                            .fontWeight(.semibold)

                        Text("(\(restaurant.reviewCount))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Delivery Time
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                            .foregroundColor(.secondary)
                            .font(.caption)

                        Text(restaurant.deliveryTime)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                HStack {
                    // Address
                    HStack(spacing: 4) {
                        Image(systemName: "location")
                            .foregroundColor(.secondary)
                            .font(.caption)

                        Text(restaurant.address)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Delivery Fee
                    Text("Delivery: $\(restaurant.deliveryFee, specifier: "%.2f")")
                        .font(.caption)
                        .foregroundColor(.green)
                        .fontWeight(.semibold)
                }

                // Action Buttons
                HStack(spacing: 12) {
                    Button("Save") {
                        // Save to favorites
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .frame(maxWidth: .infinity)

                    Button(restaurant.isOpen ? "View Menu" : "Closed") {
                        // View menu
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .frame(maxWidth: .infinity)
                    .disabled(!restaurant.isOpen)
                    .tint(restaurant.cuisineColor)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct SortChip: View {
    @Binding var selectedSort: String
    let title: String

    var body: some View {
        Menu {
            Button("Rating") { selectedSort = "Rating" }
            Button("Distance") { selectedSort = "Distance" }
            Button("Price") { selectedSort = "Price" }
            Button("Delivery Time") { selectedSort = "Delivery Time" }
        } label: {
            HStack {
                Image(systemName: "arrow.up.arrow.down")
                    .font(.caption)
                Text(title)
                    .font(.caption)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
                .foregroundColor(isSelected ? .blue : .primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FilterSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Cuisine Type") {
                    ForEach(["Italian", "Japanese", "Mexican", "French", "Chinese", "Indian"], id: \.self) { cuisine in
                        HStack {
                            Text(cuisine)
                            Spacer()
                            // Toggle would go here
                        }
                    }
                }

                Section("Price Range") {
                    ForEach(PriceRange.allCases, id: \.self) { range in
                        HStack {
                            Text(range.displayText)
                            Spacer()
                            // Toggle would go here
                        }
                    }
                }

                Section("Features") {
                    HStack {
                        Text("Open Now")
                        Spacer()
                        // Toggle would go here
                    }

                    HStack {
                        Text("Free Delivery")
                        Spacer()
                        // Toggle would go here
                    }
                }
            }
            .navigationTitle("Filter Options")
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

enum PriceRange: Int, CaseIterable {
    case budget = 1
    case moderate = 2
    case expensive = 3

    var displayText: String {
        switch self {
        case .budget: return "$"
        case .moderate: return "$$"
        case .expensive: return "$$$"
        }
    }

    var color: Color {
        switch self {
        case .budget: return .green
        case .moderate: return .orange
        case .expensive: return .red
        }
    }
}

struct Restaurant: Identifiable {
    let id: String
    let name: String
    let cuisine: String
    let rating: Double
    let reviewCount: Int
    let priceRange: PriceRange
    let deliveryTime: String
    let deliveryFee: Double
    let distance: Double
    let isOpen: Bool
    let isFeatured: Bool
    let address: String

    var cuisineColor: Color {
        switch cuisine {
        case "Italian": return .red
        case "Japanese": return .pink
        case "Mexican": return .orange
        case "French": return .purple
        case "Chinese": return .red
        case "Indian": return .orange
        default: return .blue
        }
    }
}

#Preview {
    RestaurantsListScreen()
}