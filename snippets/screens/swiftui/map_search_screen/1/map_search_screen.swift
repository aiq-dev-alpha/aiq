import SwiftUI
import MapKit

struct LocationResult {
    let id: String
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let category: String?
    let rating: Double?
    let reviewCount: Int?
    let phoneNumber: String?
    let website: String?
    let hours: [String]
    let distance: Double
    let priceLevel: String?
}

struct MapSearchScreen: View {
    @State private var searchText = ""
    @State private var searchResults: [LocationResult] = []
    @State private var selectedLocation: LocationResult?
    @State private var isLoading = false
    @State private var showList = false
    @State private var currentRadius = 5.0
    @State private var selectedCategory = "all"
    @State private var sortBy = "distance"
    @State private var showFilterSheet = false

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    private let categories = [
        "all", "restaurants", "shopping", "gas_stations", "hospitals",
        "banks", "hotels", "parks", "schools", "entertainment"
    ]

    var body: some View {
        ZStack {
            // Map View
            Map(coordinateRegion: $region, annotationItems: searchResults) { result in
                MapAnnotation(coordinate: result.coordinate) {
                    Button {
                        selectedLocation = result
                    } label: {
                        VStack {
                            Image(systemName: categoryIcon(result.category ?? ""))
                                .font(.caption)
                                .foregroundColor(.white)
                                .frame(width: 24, height: 24)
                                .background(
                                    selectedLocation?.id == result.id ? Color.red : Color.blue
                                )
                                .clipShape(Circle())
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            .ignoresSafeArea()

            VStack {
                // Search Header
                VStack(spacing: 16) {
                    HStack {
                        Button {
                            // Navigate back
                        } label: {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.primary)
                        }

                        TextField("Search for places...", text: $searchText)
                            .textFieldStyle(.plain)
                            .onSubmit {
                                performSearch()
                            }

                        Button {
                            performSearch()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.primary)
                        }

                        Button {
                            showFilterSheet = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.primary)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)

                    // Quick Filter Chips
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            quickFilterChip("All", category: "all")
                            quickFilterChip("Restaurants", category: "restaurants")
                            quickFilterChip("Shopping", category: "shopping")
                            quickFilterChip("Gas", category: "gas_stations")
                            quickFilterChip("Hotels", category: "hotels")
                            quickFilterChip("Parks", category: "parks")
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                Spacer()

                // Results Toggle Button
                if !searchResults.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            showList.toggle()
                        } label: {
                            Image(systemName: showList ? "map" : "list.bullet")
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 2)
                        }
                        .padding(.trailing)
                    }
                }
            }

            // Bottom Content
            if !searchResults.isEmpty {
                VStack {
                    Spacer()

                    if showList {
                        resultsList
                    } else {
                        resultsCarousel
                    }
                }
            }

            // Loading Overlay
            if isLoading {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .overlay {
                        ProgressView()
                            .scaleEffect(1.5)
                    }
            }
        }
        .sheet(isPresented: $showFilterSheet) {
            filterSheet
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                centerOnUserLocation()
            } label: {
                Image(systemName: "location.fill")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .shadow(radius: 2)
            }
            .padding()
        }
    }

    private func quickFilterChip(_ title: String, category: String) -> some View {
        let isSelected = selectedCategory == category

        return Button {
            selectedCategory = category
            if !searchText.isEmpty {
                performSearch()
            }
        } label: {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color(.systemBackground))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .shadow(radius: isSelected ? 0 : 1)
        }
        .buttonStyle(.plain)
    }

    private var resultsCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(searchResults, id: \.id) { result in
                    resultCard(result)
                        .frame(width: 300)
                        .onTapGesture {
                            selectedLocation = result
                        }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 200)
    }

    private var resultsList: some View {
        VStack(spacing: 0) {
            // Handle
            Capsule()
                .frame(width: 40, height: 4)
                .foregroundColor(.gray)
                .padding(.vertical, 8)

            // Header
            HStack {
                Text("\(searchResults.count) results")
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                Button {
                    // Show sort options
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
            .padding(.horizontal)
            .padding(.bottom, 8)

            // Results List
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(searchResults, id: \.id) { result in
                        resultListItem(result)
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
        .background(Color(.systemBackground))
        .cornerRadius(20)
    }

    private func resultCard(_ result: LocationResult) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon(result.category ?? ""))
                    .foregroundColor(.accentColor)

                Text(result.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)

                Spacer()
            }

            Text(result.address)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)

            HStack {
                if let rating = result.rating {
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                            .font(.caption)
                        Text(String(format: "%.1f", rating))
                            .font(.caption)
                        if let reviewCount = result.reviewCount {
                            Text("(\(reviewCount))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()

                HStack(spacing: 2) {
                    Image(systemName: "figure.walk")
                        .font(.caption)
                    Text(String(format: "%.1f km", result.distance))
                        .font(.caption)
                }
                .foregroundColor(.secondary)

                if let priceLevel = result.priceLevel {
                    Text(priceLevel)
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }

            Spacer()

            HStack(spacing: 20) {
                actionButton("Call", icon: "phone") {
                    callLocation(result)
                }

                actionButton("Directions", icon: "arrow.triangle.turn.up.right.diamond") {
                    getDirections(result)
                }

                actionButton("Share", icon: "square.and.arrow.up") {
                    shareLocation(result)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 4)
    }

    private func resultListItem(_ result: LocationResult) -> some View {
        HStack(spacing: 12) {
            Image(systemName: categoryIcon(result.category ?? ""))
                .foregroundColor(.accentColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.name)
                    .font(.body)
                    .fontWeight(.bold)

                Text(result.address)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)

                HStack(spacing: 8) {
                    if let rating = result.rating {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption2)
                            Text(String(format: "%.1f", rating))
                                .font(.caption2)
                            Text("(\(result.reviewCount ?? 0))")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }

                    Text(String(format: "%.1f km", result.distance))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                // Show more options
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(8)
        .onTapGesture {
            selectedLocation = result
            showList = false
        }
    }

    private func actionButton(_ title: String, icon: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.caption)
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(.accentColor)
        }
        .buttonStyle(.plain)
    }

    private var filterSheet: some View {
        VStack(spacing: 20) {
            Text("Filter & Sort")
                .font(.headline)
                .fontWeight(.bold)

            // Search Radius
            VStack(alignment: .leading) {
                Text("Search Radius: \(Int(currentRadius)) km")
                    .font(.subheadline)

                Slider(value: $currentRadius, in: 1...50, step: 1)
            }

            // Category Filter
            VStack(alignment: .leading) {
                Text("Category")
                    .font(.subheadline)

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(getCategoryDisplayName(category)).tag(category)
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 120)
            }

            // Sort Options
            VStack(alignment: .leading) {
                Text("Sort by")
                    .font(.subheadline)

                Picker("Sort by", selection: $sortBy) {
                    Text("Distance").tag("distance")
                    Text("Rating").tag("rating")
                    Text("Name").tag("name")
                    Text("Most Reviewed").tag("reviews")
                }
                .pickerStyle(.segmented)
            }

            Button("Apply Filters") {
                showFilterSheet = false
                performSearch()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .presentationDetents([.medium])
    }

    private func categoryIcon(_ category: String) -> String {
        switch category {
        case "restaurant", "restaurants":
            return "fork.knife"
        case "shopping":
            return "bag"
        case "gas_station", "gas_stations":
            return "fuelpump"
        case "hospital", "hospitals":
            return "cross.case"
        case "bank", "banks":
            return "building.columns"
        case "hotel", "hotels":
            return "bed.double"
        case "park", "parks":
            return "tree"
        case "school", "schools":
            return "graduationcap"
        case "entertainment":
            return "tv"
        default:
            return "mappin"
        }
    }

    private func getCategoryDisplayName(_ category: String) -> String {
        switch category {
        case "all": return "All Categories"
        case "restaurants": return "Restaurants"
        case "shopping": return "Shopping"
        case "gas_stations": return "Gas Stations"
        case "hospitals": return "Hospitals"
        case "banks": return "Banks"
        case "hotels": return "Hotels"
        case "parks": return "Parks"
        case "schools": return "Schools"
        case "entertainment": return "Entertainment"
        default: return category.capitalized
        }
    }

    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        isLoading = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            searchResults = generateMockResults()
            isLoading = false
            if let firstResult = searchResults.first {
                selectedLocation = firstResult
            }
        }
    }

    private func generateMockResults() -> [LocationResult] {
        let mockPlaces = [
            ("\(searchText) at Union Square", "123 Union Square, San Francisco, CA", "restaurant", 4.5, 324, 0.8, "+1 (415) 123-4567", "$$"),
            ("\(searchText) Downtown", "456 Market Street, San Francisco, CA", "shopping", 4.2, 156, 1.2, "+1 (415) 234-5678", "$$$"),
            ("\(searchText) Mission District", "789 Mission Street, San Francisco, CA", "restaurant", 4.7, 245, 2.1, "+1 (415) 345-6789", "$"),
            ("\(searchText) Financial District", "321 Montgomery Street, San Francisco, CA", "bank", 3.9, 89, 0.6, "+1 (415) 456-7890", nil),
            ("\(searchText) Chinatown", "654 Grant Avenue, San Francisco, CA", "restaurant", 4.4, 198, 1.8, "+1 (415) 567-8901", "$$"),
        ]

        return mockPlaces.enumerated().map { index, place in
            LocationResult(
                id: "location_\(index)",
                name: place.0,
                address: place.1,
                coordinate: CLLocationCoordinate2D(
                    latitude: region.center.latitude + Double(index) * 0.01,
                    longitude: region.center.longitude + Double(index) * 0.01
                ),
                category: place.2,
                rating: place.3,
                reviewCount: place.4,
                phoneNumber: place.6,
                website: nil,
                hours: ["Mon-Fri: 9:00 AM - 9:00 PM", "Sat-Sun: 10:00 AM - 8:00 PM"],
                distance: place.5,
                priceLevel: place.7
            )
        }
    }

    private func centerOnUserLocation() {
        // Center map on user location
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        selectedLocation = nil
    }

    private func callLocation(_ result: LocationResult) {
        if let phoneNumber = result.phoneNumber {
            if let url = URL(string: "tel:\(phoneNumber)") {
                UIApplication.shared.open(url)
            }
        }
    }

    private func getDirections(_ result: LocationResult) {
        let placemark = MKPlacemark(coordinate: result.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = result.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving])
    }

    private func shareLocation(_ result: LocationResult) {
        let activityController = UIActivityViewController(
            activityItems: [result.name, result.address],
            applicationActivities: nil
        )

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityController, animated: true)
        }
    }
}

#Preview {
    MapSearchScreen()
}