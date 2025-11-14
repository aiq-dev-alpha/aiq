import SwiftUI

struct HotelDetailScreen: View {
    let hotel: Hotel
    @State private var selectedTab = 0
    @State private var isFavorite = false
    @State private var checkInDate = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    @State private var checkOutDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
    @State private var guests = 2
    @State private var rooms = 1

    var nightCount: Int {
        Calendar.current.dateComponents([.day], from: checkInDate, to: checkOutDate).day ?? 0
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Hotel Header
                HotelHeaderView(hotel: hotel, isFavorite: $isFavorite)

                // Hotel Info Cards
                HotelInfoCardsView(hotel: hotel)

                // Booking Section
                BookingSectionView(
                    hotel: hotel,
                    checkInDate: $checkInDate,
                    checkOutDate: $checkOutDate,
                    guests: $guests,
                    rooms: $rooms,
                    nightCount: nightCount
                )

                // Tab Bar
                HotelTabBar(selectedTab: $selectedTab)

                // Tab Content
                Group {
                    switch selectedTab {
                    case 0: HotelRoomsTab(hotel: hotel)
                    case 1: HotelAmenitiesTab(hotel: hotel)
                    case 2: HotelReviewsTab(hotel: hotel)
                    case 3: HotelLocationTab(hotel: hotel)
                    default: HotelRoomsTab(hotel: hotel)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct HotelHeaderView: View {
    let hotel: Hotel
    @Binding var isFavorite: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 0)
                .fill(hotel.hotelType.color.gradient)
                .frame(height: 200)
                .overlay(
                    VStack {
                        if !hotel.isAvailable {
                            VStack {
                                Image(systemName: "bed.double")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Fully Booked")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Try different dates")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5))
                        } else {
                            Image(systemName: "building.2")
                                .font(.system(size: 60))
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                )

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if hotel.isFeatured {
                        Text("Featured")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text(hotel.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(hotel.hotelType.displayName)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()

                VStack(alignment: .trailing) {
                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .font(.title2)
                            .foregroundColor(isFavorite ? .red : .white)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct HotelInfoCardsView: View {
    let hotel: Hotel

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
            InfoCard(
                icon: "star.fill",
                iconColor: .yellow,
                title: "Rating",
                subtitle: String(format: "%.1f", hotel.rating),
                detail: "\(hotel.reviewCount) reviews"
            )
            InfoCard(
                icon: "location",
                iconColor: .blue,
                title: "Distance",
                subtitle: "\(hotel.distanceFromCenter, specifier: "%.1f") km",
                detail: "from center"
            )
            InfoCard(
                icon: "car",
                iconColor: .green,
                title: "Parking",
                subtitle: "Available",
                detail: "Free"
            )
        }
        .padding()
    }
}

struct BookingSectionView: View {
    let hotel: Hotel
    @Binding var checkInDate: Date
    @Binding var checkOutDate: Date
    @Binding var guests: Int
    @Binding var rooms: Int
    let nightCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Book Your Stay")
                .font(.headline)
                .fontWeight(.bold)

            // Date Selection
            HStack(spacing: 12) {
                DateSelectorView(
                    title: "Check-in",
                    date: $checkInDate
                )

                DateSelectorView(
                    title: "Check-out",
                    date: $checkOutDate
                )
            }

            // Guest and Room Selection
            HStack(spacing: 12) {
                CountSelectorView(
                    title: "Guests",
                    count: $guests,
                    range: 1...10
                )

                CountSelectorView(
                    title: "Rooms",
                    count: $rooms,
                    range: 1...5
                )
            }

            // Stay Summary
            VStack(spacing: 8) {
                HStack {
                    Text("Stay Duration:")
                    Spacer()
                    Text("\(nightCount) nights")
                }

                HStack {
                    Text("Price per night:")
                    Spacer()
                    Text("$\(Int(hotel.pricePerNight))")
                }

                Divider()

                HStack {
                    Text("Total:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("$\(Int(hotel.pricePerNight * Double(nightCount * rooms)))")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct DateSelectorView: View {
    let title: String
    @Binding var date: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            DatePicker("", selection: $date, displayedComponents: .date)
                .datePickerStyle(CompactDatePickerStyle())
                .labelsHidden()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct CountSelectorView: View {
    let title: String
    @Binding var count: Int
    let range: ClosedRange<Int>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            HStack {
                Text("\(count)")
                    .font(.title3)
                    .fontWeight(.semibold)

                Spacer()

                HStack(spacing: 8) {
                    Button {
                        if count > range.lowerBound {
                            count -= 1
                        }
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 24, height: 24)
                            .background(count > range.lowerBound ? Color(.systemGray5) : Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(count <= range.lowerBound)

                    Button {
                        if count < range.upperBound {
                            count += 1
                        }
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 24, height: 24)
                            .background(count < range.upperBound ? Color(.systemGray5) : Color(.systemGray6))
                            .clipShape(Circle())
                    }
                    .disabled(count >= range.upperBound)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct HotelTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(["Rooms", "Amenities", "Reviews", "Location"].indices, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    Text(["Rooms", "Amenities", "Reviews", "Location"][index])
                        .font(.subheadline)
                        .fontWeight(selectedTab == index ? .semibold : .regular)
                        .foregroundColor(selectedTab == index ? .blue : .secondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Rectangle()
                                .fill(selectedTab == index ? Color.blue.opacity(0.1) : Color.clear)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(Color(.systemBackground))
        .overlay(
            Rectangle()
                .fill(Color(.systemGray4))
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

struct HotelRoomsTab: View {
    let hotel: Hotel

    let roomTypes = [
        RoomType(id: "1", name: "Standard Room", description: "Comfortable room with essential amenities", price: 95.00, originalPrice: 120.00, size: 25, maxGuests: 2, bedType: "Queen Bed", isAvailable: true),
        RoomType(id: "2", name: "Deluxe King Room", description: "Spacious room with city view and premium amenities", price: 180.00, originalPrice: 220.00, size: 35, maxGuests: 2, bedType: "King Bed", isAvailable: true),
        RoomType(id: "3", name: "Executive Suite", description: "Luxurious suite with separate living area", price: 320.00, originalPrice: 380.00, size: 55, maxGuests: 4, bedType: "King Bed + Sofa Bed", isAvailable: false)
    ]

    var body: some View {
        LazyVStack(spacing: 16) {
            ForEach(roomTypes) { room in
                RoomTypeCard(room: room, hotel: hotel)
            }
        }
        .padding()
    }
}

struct RoomTypeCard: View {
    let room: RoomType
    let hotel: Hotel

    var discountPercent: Int {
        guard room.originalPrice > room.price else { return 0 }
        return Int(((room.originalPrice - room.price) / room.originalPrice) * 100)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(room.name)
                    .font(.headline)
                    .fontWeight(.bold)

                Spacer()

                if !room.isAvailable {
                    Text("Unavailable")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }

            Text(room.description)
                .font(.body)
                .foregroundColor(.secondary)

            // Room Details
            HStack(spacing: 16) {
                RoomDetail(icon: "bed", text: "\(room.size) m²")
                RoomDetail(icon: "person.2", text: "\(room.maxGuests) guests")
                RoomDetail(icon: "bed.double", text: room.bedType)
            }

            // Price and Booking
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    if discountPercent > 0 {
                        HStack(spacing: 8) {
                            Text("$\(Int(room.originalPrice))")
                                .font(.caption)
                                .strikethrough()
                                .foregroundColor(.secondary)

                            Text("\(discountPercent)% OFF")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 4))
                        }
                    }

                    HStack(alignment: .bottom, spacing: 4) {
                        Text("$\(Int(room.price))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)

                        Text("per night")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(room.isAvailable && hotel.isAvailable ? "Select Room" : "Unavailable") {
                    // Book room
                }
                .buttonStyle(.borderedProminent)
                .disabled(!room.isAvailable || !hotel.isAvailable)
                .tint(hotel.hotelType.color)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct RoomDetail: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .font(.caption)

            Text(text)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct HotelAmenitiesTab: View {
    let hotel: Hotel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            AmenitySection(title: "General", amenities: [
                ("wifi", "Free WiFi", true),
                ("car", "Free Parking", true),
                ("pawprint", "Pet Friendly", false),
                ("figure.roll", "Wheelchair Accessible", true)
            ])

            AmenitySection(title: "Recreation", amenities: [
                ("figure.pool.swim", "Swimming Pool", true),
                ("dumbbell", "Fitness Center", true),
                ("leaf", "Spa Services", hotel.hotelType == .luxury),
                ("sportscourt", "Tennis Court", hotel.hotelType == .resort)
            ])

            AmenitySection(title: "Services", amenities: [
                ("fork.knife", "Restaurant", true),
                ("wineglass", "Bar/Lounge", hotel.hotelType != .budget),
                ("bell", "Room Service", hotel.hotelType == .luxury),
                ("briefcase", "Business Center", hotel.hotelType == .business || hotel.hotelType == .luxury)
            ])
        }
        .padding()
    }
}

struct AmenitySection: View {
    let title: String
    let amenities: [(String, String, Bool)]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 8) {
                ForEach(amenities.indices, id: \.self) { index in
                    let amenity = amenities[index]
                    HStack {
                        Image(systemName: amenity.0)
                            .foregroundColor(amenity.2 ? .green : .gray)
                            .frame(width: 20)

                        Text(amenity.1)
                            .foregroundColor(amenity.2 ? .primary : .secondary)

                        Spacer()

                        Image(systemName: amenity.2 ? "checkmark" : "xmark")
                            .foregroundColor(amenity.2 ? .green : .red)
                            .font(.caption)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct HotelReviewsTab: View {
    let hotel: Hotel

    var body: some View {
        LazyVStack(spacing: 16) {
            // Rating Overview
            VStack(spacing: 16) {
                HStack {
                    VStack {
                        Text(String(format: "%.1f", hotel.rating))
                            .font(.largeTitle)
                            .fontWeight(.bold)

                        HStack {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(hotel.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }

                        Text("\(hotel.reviewCount) reviews")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 8) {
                        RatingBar(category: "Cleanliness", rating: 4.8)
                        RatingBar(category: "Location", rating: 4.6)
                        RatingBar(category: "Service", rating: 4.7)
                        RatingBar(category: "Value", rating: 4.5)
                    }
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Sample Reviews
            ForEach(0..<3) { index in
                ReviewCard(index: index)
            }
        }
        .padding()
    }
}

struct RatingBar: View {
    let category: String
    let rating: Double

    var body: some View {
        HStack {
            Text(category)
                .font(.caption)
                .frame(width: 80, alignment: .leading)

            ProgressView(value: rating / 5.0)
                .progressViewStyle(LinearProgressViewStyle(tint: .yellow))

            Text(String(format: "%.1f", rating))
                .font(.caption)
                .fontWeight(.semibold)
        }
    }
}

struct ReviewCard: View {
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                    .overlay(Text("G\(index + 1)"))

                VStack(alignment: .leading) {
                    Text("Guest \(index + 1)")
                        .fontWeight(.semibold)

                    HStack {
                        ForEach(0..<5) { starIndex in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        Text("1 week ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }

            Text("Excellent hotel with great service and amenities. The room was spacious and clean. Would definitely stay here again!")
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct HotelLocationTab: View {
    let hotel: Hotel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Map Placeholder
            VStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray5))
                    .frame(height: 200)
                    .overlay(
                        VStack {
                            Image(systemName: "map")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Map View")
                                .foregroundColor(.gray)
                        }
                    )
            }

            // Address and Contact
            VStack(alignment: .leading, spacing: 12) {
                Text("Address")
                    .font(.headline)
                    .fontWeight(.bold)

                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.red)
                        Text(hotel.address)
                        Spacer()
                        Button("Directions") { }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                    .padding()

                    Divider()

                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.green)
                        Text("+1 555-0199")
                        Spacer()
                        Button("Call") { }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                    .padding()
                }
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Nearby Attractions
            VStack(alignment: .leading, spacing: 12) {
                Text("Nearby Attractions")
                    .font(.headline)
                    .fontWeight(.bold)

                VStack(spacing: 8) {
                    NearbyAttractionRow(icon: "tree", name: "Central Park", distance: "0.3 km")
                    NearbyAttractionRow(icon: "bag", name: "Shopping Mall", distance: "0.8 km")
                    NearbyAttractionRow(icon: "building.columns", name: "Museum of Art", distance: "1.2 km")
                    NearbyAttractionRow(icon: "airplane", name: "International Airport", distance: "25 km")
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
}

struct NearbyAttractionRow: View {
    let icon: String
    let name: String
    let distance: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)

            Text(name)

            Spacer()

            Text(distance)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct RoomType: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let originalPrice: Double
    let size: Int
    let maxGuests: Int
    let bedType: String
    let isAvailable: Bool
}

#Preview {
    NavigationStack {
        HotelDetailScreen(
            hotel: Hotel(
                id: "1",
                name: "Grand Plaza Hotel",
                address: "123 Downtown Ave, City Center",
                rating: 4.8,
                reviewCount: 1247,
                pricePerNight: 180.00,
                originalPrice: 220.00,
                distanceFromCenter: 0.5,
                hotelType: .luxury,
                isAvailable: true,
                isFeatured: true,
                hasFreeCancellation: true,
                breakfastIncluded: true,
                roomType: "Deluxe King Room"
            )
        )
    }
}