import SwiftUI

struct HotelsListScreen: View {
    @State private var searchText = ""
    @State private var selectedSort = "Price"
    @State private var priceRange = 50.0...300.0
    @State private var minRating = 3.0
    @State private var showingFilter = false

    let hotels = [
        Hotel(id: "1", name: "Grand Plaza Hotel", address: "123 Downtown Ave, City Center", rating: 4.8, reviewCount: 1247, pricePerNight: 180.00, originalPrice: 220.00, distanceFromCenter: 0.5, hotelType: .luxury, isAvailable: true, isFeatured: true, hasFreeCancellation: true, breakfastIncluded: true, roomType: "Deluxe King Room"),
        Hotel(id: "2", name: "City Comfort Inn", address: "456 Main St, Business District", rating: 4.2, reviewCount: 893, pricePerNight: 95.00, originalPrice: 120.00, distanceFromCenter: 1.2, hotelType: .business, isAvailable: true, isFeatured: false, hasFreeCancellation: true, breakfastIncluded: true, roomType: "Standard Double Room"),
        Hotel(id: "3", name: "Sunset Beach Resort", address: "789 Ocean Drive, Beachfront", rating: 4.6, reviewCount: 654, pricePerNight: 250.00, originalPrice: 300.00, distanceFromCenter: 5.8, hotelType: .resort, isAvailable: true, isFeatured: true, hasFreeCancellation: false, breakfastIncluded: false, roomType: "Ocean View Suite"),
        Hotel(id: "4", name: "Budget Stay Motel", address: "321 Highway Rd, Airport Area", rating: 3.8, reviewCount: 234, pricePerNight: 65.00, originalPrice: 75.00, distanceFromCenter: 8.2, hotelType: .budget, isAvailable: true, isFeatured: false, hasFreeCancellation: true, breakfastIncluded: false, roomType: "Standard Room")
    ]

    var filteredHotels: [Hotel] {
        var filtered = hotels

        if !searchText.isEmpty {
            filtered = filtered.filter { hotel in
                hotel.name.localizedCaseInsensitiveContains(searchText) ||
                hotel.address.localizedCaseInsensitiveContains(searchText)
            }
        }

        filtered = filtered.filter { hotel in
            hotel.pricePerNight >= priceRange.lowerBound &&
            hotel.pricePerNight <= priceRange.upperBound &&
            hotel.rating >= minRating
        }

        filtered = filtered.sorted { first, second in
            if first.isFeatured && !second.isFeatured { return true }
            if !first.isFeatured && second.isFeatured { return false }
            if first.isAvailable && !second.isAvailable { return true }
            if !first.isAvailable && second.isAvailable { return false }

            switch selectedSort {
            case "Price": return first.pricePerNight < second.pricePerNight
            case "Rating": return first.rating > second.rating
            case "Distance": return first.distanceFromCenter < second.distanceFromCenter
            default: return first.pricePerNight < second.pricePerNight
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

                // Quick Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        SortChip(selectedSort: $selectedSort, title: "Sort: \(selectedSort)")

                        FilterChip(title: "$\(Int(priceRange.lowerBound))-$\(Int(priceRange.upperBound))", isSelected: priceRange.lowerBound != 50 || priceRange.upperBound != 300) {
                            showingFilter = true
                        }

                        FilterChip(title: "\(minRating, specifier: "%.1f")+ Rating", isSelected: minRating != 3.0) {
                            showingFilter = true
                        }

                        FilterChip(title: "Available Only", isSelected: false) { }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                // Results Count
                HStack {
                    Text("\(filteredHotels.count) hotels found")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Spacer()

                    Button("Clear Filters") {
                        clearFilters()
                    }
                    .font(.caption)
                }
                .padding(.horizontal)

                if filteredHotels.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "building.2")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No hotels found")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Text("Try adjusting your search criteria or filters")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                } else {
                    // Hotels List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredHotels) { hotel in
                                NavigationLink(destination: HotelDetailScreen(hotel: hotel)) {
                                    HotelCard(hotel: hotel)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Hotels")
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
                HotelFilterSheet(priceRange: $priceRange, minRating: $minRating)
            }
        }
    }

    private func clearFilters() {
        priceRange = 50.0...300.0
        minRating = 3.0
        searchText = ""
    }
}

struct HotelCard: View {
    let hotel: Hotel

    var discountPercent: Int {
        guard hotel.originalPrice > hotel.pricePerNight else { return 0 }
        return Int(((hotel.originalPrice - hotel.pricePerNight) / hotel.originalPrice) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Hotel Header Image
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(hotel.hotelType.color.gradient)
                    .frame(height: 200)

                // Badges
                VStack(alignment: .leading, spacing: 6) {
                    if hotel.isFeatured {
                        Text("Featured")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    if !hotel.isAvailable {
                        Text("Fully Booked")
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

                // Discount badge (top right)
                if discountPercent > 0 {
                    HStack {
                        Spacer()
                        Text("\(discountPercent)% OFF")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding(12)
                    }
                }
            }

            // Hotel Info
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(hotel.name)
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Text(hotel.hotelType.displayName)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(hotel.hotelType.color.opacity(0.1))
                        .foregroundColor(hotel.hotelType.color)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.secondary)
                        .font(.caption)

                    Text(hotel.address)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Spacer()

                    Text("\(hotel.distanceFromCenter, specifier: "%.1f") km from center")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                HStack {
                    // Rating
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)

                        Text(String(format: "%.1f", hotel.rating))
                            .font(.caption)
                            .fontWeight(.semibold)

                        Text("(\(hotel.reviewCount) reviews)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }

                Text(hotel.roomType)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                // Features
                HStack {
                    if hotel.hasFreeCancellation {
                        FeatureBadge(icon: "checkmark.circle", text: "Free cancellation", color: .green)
                    }

                    if hotel.breakfastIncluded {
                        FeatureBadge(icon: "cup.and.saucer", text: "Breakfast included", color: .orange)
                    }
                }

                // Price and Booking
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        if hotel.originalPrice > hotel.pricePerNight {
                            Text("$\(Int(hotel.originalPrice))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }

                        HStack(alignment: .bottom, spacing: 4) {
                            Text("$\(Int(hotel.pricePerNight))")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.green)

                            Text("/ night")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()

                    Button(hotel.isAvailable ? "Book Now" : "Fully Booked") {
                        // Book hotel
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                    .disabled(!hotel.isAvailable)
                    .tint(hotel.hotelType.color)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct FeatureBadge: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.caption2)
            Text(text)
                .font(.caption2)
        }
        .foregroundColor(color)
        .fontWeight(.medium)
    }
}

struct HotelFilterSheet: View {
    @Binding var priceRange: ClosedRange<Double>
    @Binding var minRating: Double
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Price Range (per night)") {
                    VStack {
                        HStack {
                            Text("$\(Int(priceRange.lowerBound))")
                            Spacer()
                            Text("$\(Int(priceRange.upperBound))")
                        }
                        .font(.caption)

                        RangeSlider(range: $priceRange, bounds: 50...500)
                    }
                }

                Section("Minimum Rating") {
                    VStack {
                        HStack {
                            ForEach(1...5, id: \.self) { rating in
                                Image(systemName: Double(rating) <= minRating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .onTapGesture {
                                        minRating = Double(rating)
                                    }
                            }
                            Spacer()
                            Text("\(minRating, specifier: "%.1f") stars")
                                .font(.caption)
                        }

                        Slider(value: $minRating, in: 1...5, step: 0.5)
                    }
                }

                Section("Hotel Type") {
                    ForEach(HotelType.allCases, id: \.self) { type in
                        HStack {
                            Circle()
                                .fill(type.color)
                                .frame(width: 12, height: 12)
                            Text(type.displayName)
                            Spacer()
                            // Toggle would go here
                        }
                    }
                }

                Section("Amenities") {
                    ForEach(["WiFi", "Pool", "Gym", "Spa", "Restaurant", "Parking"], id: \.self) { amenity in
                        HStack {
                            Text(amenity)
                            Spacer()
                            // Toggle would go here
                        }
                    }
                }
            }
            .navigationTitle("Filter Hotels")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        priceRange = 50.0...300.0
                        minRating = 3.0
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// Simple range slider implementation
struct RangeSlider: View {
    @Binding var range: ClosedRange<Double>
    let bounds: ClosedRange<Double>

    var body: some View {
        // Simplified range slider - in production you'd use a proper implementation
        VStack {
            HStack {
                Slider(value: Binding(
                    get: { range.lowerBound },
                    set: { newValue in
                        range = newValue...max(newValue, range.upperBound)
                    }
                ), in: bounds)

                Slider(value: Binding(
                    get: { range.upperBound },
                    set: { newValue in
                        range = min(range.lowerBound, newValue)...newValue
                    }
                ), in: bounds)
            }
        }
    }
}

enum HotelType: CaseIterable {
    case luxury, business, budget, resort, boutique

    var displayName: String {
        switch self {
        case .luxury: return "Luxury"
        case .business: return "Business"
        case .budget: return "Budget"
        case .resort: return "Resort"
        case .boutique: return "Boutique"
        }
    }

    var color: Color {
        switch self {
        case .luxury: return .purple
        case .business: return .blue
        case .budget: return .green
        case .resort: return .orange
        case .boutique: return .pink
        }
    }
}

struct Hotel: Identifiable {
    let id: String
    let name: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let pricePerNight: Double
    let originalPrice: Double
    let distanceFromCenter: Double
    let hotelType: HotelType
    let isAvailable: Bool
    let isFeatured: Bool
    let hasFreeCancellation: Bool
    let breakfastIncluded: Bool
    let roomType: String
}

#Preview {
    HotelsListScreen()
}