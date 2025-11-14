import SwiftUI

struct EventsListScreen: View {
    @State private var searchText = ""
    @State private var selectedTab = 0
    @State private var showingFilter = false
    @State private var showingCreateEvent = false

    let events = [
        Event(
            id: "1",
            title: "Flutter Dev Conference",
            description: "Annual Flutter developer conference with latest updates and best practices.",
            date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            location: "San Francisco, CA",
            category: .technology,
            attendees: 250,
            price: 299.0,
            imageUrl: "https://via.placeholder.com/300x200"
        ),
        Event(
            id: "2",
            title: "Jazz Night at Blue Note",
            description: "Experience smooth jazz with world-class musicians in an intimate setting.",
            date: Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date(),
            location: "New York, NY",
            category: .music,
            attendees: 120,
            price: 45.0,
            imageUrl: "https://via.placeholder.com/300x200"
        ),
        Event(
            id: "3",
            title: "Local Food Festival",
            description: "Taste the best local cuisine from over 50 vendors and restaurants.",
            date: Calendar.current.date(byAdding: .day, value: 14, to: Date()) ?? Date(),
            location: "Austin, TX",
            category: .food,
            attendees: 500,
            price: 25.0,
            imageUrl: "https://via.placeholder.com/300x200"
        ),
        Event(
            id: "4",
            title: "Modern Art Exhibition",
            description: "Discover contemporary artworks from emerging and established artists.",
            date: Calendar.current.date(byAdding: .day, value: 21, to: Date()) ?? Date(),
            location: "Los Angeles, CA",
            category: .art,
            attendees: 150,
            price: 20.0,
            imageUrl: "https://via.placeholder.com/300x200"
        ),
        Event(
            id: "5",
            title: "Marathon Training Workshop",
            description: "Learn proper training techniques and nutrition for marathon running.",
            date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(),
            location: "Boston, MA",
            category: .sports,
            attendees: 75,
            price: 50.0,
            imageUrl: "https://via.placeholder.com/300x200"
        )
    ]

    var filteredEvents: [Event] {
        let filtered: [Event]

        switch selectedTab {
        case 0: // All
            filtered = events
        case 1: // This Week
            let oneWeekFromNow = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()
            filtered = events.filter { $0.date < oneWeekFromNow }
        case 2: // This Month
            let oneMonthFromNow = Calendar.current.date(byAdding: .day, value: 30, to: Date()) ?? Date()
            filtered = events.filter { $0.date < oneMonthFromNow }
        default:
            filtered = events
        }

        if searchText.isEmpty {
            return filtered
        } else {
            return filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchText) ||
                event.description.localizedCaseInsensitiveContains(searchText) ||
                event.location.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Tab Bar
                Picker("Filter", selection: $selectedTab) {
                    Text("All").tag(0)
                    Text("This Week").tag(1)
                    Text("This Month").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)

                if filteredEvents.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: "calendar.badge.plus")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))

                        Text(searchText.isEmpty ? "No events yet" : "No events found")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        if searchText.isEmpty {
                            Button("Create Event") {
                                showingCreateEvent = true
                            }
                            .buttonStyle(.bordered)
                        }

                        Spacer()
                    }
                } else {
                    // Events List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredEvents) { event in
                                NavigationLink(destination: EventDetailScreen(event: event)) {
                                    EventCardView(event: event)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)
                    }
                }
            }
            .navigationTitle("Events")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        showingFilter = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }

                    Button {
                        showingCreateEvent = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingFilter) {
                FilterEventsSheet()
            }
            .sheet(isPresented: $showingCreateEvent) {
                CreateEventSheet()
            }
        }
    }
}

struct EventCardView: View {
    let event: Event

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event Image/Header
            ZStack(alignment: .topTrailing) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                event.category.color.opacity(0.8),
                                event.category.color
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)

                // Category Badge
                Text(event.category.rawValue.capitalized)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 12)
                    .padding(.trailing, 12)

                // Event Title and Location
                VStack(alignment: .leading, spacing: 4) {
                    Spacer()

                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)

                    HStack {
                        Image(systemName: "location")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))

                        Text(event.location)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer().frame(height: 16)
                }
                .padding(.horizontal, 16)
            }

            // Event Details
            VStack(alignment: .leading, spacing: 12) {
                Text(event.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    // Date
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text(event.formattedDate)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    // Attendees
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        Text("\(event.attendees)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                HStack {
                    // Price
                    Text(event.price > 0 ? "$\(Int(event.price))" : "Free")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.green)

                    Spacer()

                    // Register Button
                    Button("Register") {
                        // Register for event
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .tint(event.category.color)
                }
            }
            .padding(16)
        }
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

struct FilterEventsSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Category") {
                    ForEach(EventCategory.allCases, id: \.self) { category in
                        HStack {
                            Circle()
                                .fill(category.color)
                                .frame(width: 12, height: 12)

                            Text(category.rawValue.capitalized)

                            Spacer()

                            // Toggle or checkmark would go here
                        }
                    }
                }

                Section("Price Range") {
                    HStack {
                        Text("Free")
                        Spacer()
                        // Toggle would go here
                    }

                    HStack {
                        Text("Under $50")
                        Spacer()
                        // Toggle would go here
                    }

                    HStack {
                        Text("$50 - $100")
                        Spacer()
                        // Toggle would go here
                    }

                    HStack {
                        Text("Over $100")
                        Spacer()
                        // Toggle would go here
                    }
                }
            }
            .navigationTitle("Filter Events")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        // Reset filters
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

struct CreateEventSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var location = ""
    @State private var selectedCategory = EventCategory.technology
    @State private var price = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Event Details") {
                    TextField("Event Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("Location", text: $location)
                }

                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(EventCategory.allCases, id: \.self) { category in
                            HStack {
                                Circle()
                                    .fill(category.color)
                                    .frame(width: 12, height: 12)

                                Text(category.rawValue.capitalized)
                            }
                            .tag(category)
                        }
                    }
                    .pickerStyle(.menu)
                }

                Section("Pricing") {
                    TextField("Price (leave empty for free)", text: $price)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Create Event")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Create") {
                        // Create event
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

enum EventCategory: String, CaseIterable {
    case technology = "technology"
    case music = "music"
    case food = "food"
    case art = "art"
    case sports = "sports"

    var color: Color {
        switch self {
        case .technology: return .blue
        case .music: return .purple
        case .food: return .orange
        case .art: return .pink
        case .sports: return .green
        }
    }
}

struct Event: Identifiable {
    let id: String
    let title: String
    let description: String
    let date: Date
    let location: String
    let category: EventCategory
    let attendees: Int
    let price: Double
    let imageUrl: String

    var formattedDate: String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let daysFromNow = calendar.dateComponents([.day], from: Date(), to: date).day ?? 0

        if daysFromNow == 0 {
            return "Today"
        } else if daysFromNow == 1 {
            return "Tomorrow"
        } else if daysFromNow < 7 {
            return "In \(daysFromNow) days"
        } else {
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
    }
}

#Preview {
    EventsListScreen()
}