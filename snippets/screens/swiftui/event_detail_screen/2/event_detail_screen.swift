import SwiftUI

struct EventDetailScreen: View {
    let event: Event
    @State private var isRegistered = false
    @State private var isFavorite = false
    @State private var selectedTickets = 1
    @State private var showingRegistration = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Event Header Image
                ZStack(alignment: .bottomLeading) {
                    RoundedRectangle(cornerRadius: 0)
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
                        .frame(height: 300)

                    VStack(alignment: .leading, spacing: 8) {
                        // Category Badge
                        Text(event.category.rawValue.capitalized)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.9))
                            .clipShape(RoundedRectangle(cornerRadius: 20))

                        // Event Title
                        Text(event.title)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(20)
                }

                // Content
                VStack(alignment: .leading, spacing: 20) {
                    // Event Info Cards
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                        EventInfoCard(
                            icon: "calendar",
                            title: "Date",
                            subtitle: event.formattedDate,
                            color: .blue
                        )

                        EventInfoCard(
                            icon: "clock",
                            title: "Time",
                            subtitle: "7:00 PM",
                            color: .green
                        )

                        EventInfoCard(
                            icon: "location",
                            title: "Location",
                            subtitle: event.location,
                            color: .red
                        )

                        EventInfoCard(
                            icon: "person.2",
                            title: "Attendees",
                            subtitle: "\(event.attendees) registered",
                            color: .purple
                        )
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About this event")
                            .font(.headline)
                            .fontWeight(.bold)

                        Text(event.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    // Location Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.headline)
                            .fontWeight(.bold)

                        VStack(spacing: 12) {
                            // Map Preview
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 200)
                                .overlay(
                                    VStack {
                                        Image(systemName: "map")
                                            .font(.system(size: 48))
                                            .foregroundColor(.gray)
                                        Text("Map Preview")
                                            .foregroundColor(.gray)
                                    }
                                )

                            HStack {
                                VStack(alignment: .leading) {
                                    Text(event.location)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text("Tap for directions")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()

                                Button("Directions") {
                                    // Open directions
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.small)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }

                    // Organizer Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Organizer")
                            .font(.headline)
                            .fontWeight(.bold)

                        HStack {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    Image(systemName: "building.2")
                                        .foregroundColor(.white)
                                )

                            VStack(alignment: .leading) {
                                Text("Event Organizers Inc.")
                                    .font(.system(size: 16, weight: .semibold))

                                Text("Professional event management company")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Button("Contact") {
                                // Contact organizer
                            }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    // Similar Events
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Similar Events")
                            .font(.headline)
                            .fontWeight(.bold)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<3) { index in
                                    SimilarEventCard(index: index, category: event.category)
                                }
                            }
                            .padding(.horizontal, 4)
                        }
                    }

                    Spacer().frame(height: 100) // Bottom padding for floating button
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button {
                    isFavorite.toggle()
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .primary)
                }

                Menu {
                    Button("Share Event") {
                        // Share event
                    }

                    Button("Add to Calendar") {
                        // Add to calendar
                    }

                    Button("Report Event") {
                        // Report event
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .overlay(alignment: .bottom) {
            // Floating Action Button
            if !isRegistered {
                Button {
                    if event.price > 0 {
                        showingRegistration = true
                    } else {
                        isRegistered = true
                    }
                } label: {
                    Text(event.price > 0 ? "Buy Tickets - $\(Int(event.price))" : "Register Free")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(event.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color(.systemBackground).opacity(0),
                            Color(.systemBackground).opacity(0.8),
                            Color(.systemBackground)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 80)
                    .allowsHitTesting(false)
                )
            } else {
                Button {
                    // Show registration details
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Registered")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showingRegistration) {
            TicketPurchaseSheet(event: event, selectedTickets: $selectedTickets) {
                isRegistered = true
            }
        }
    }
}

struct EventInfoCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)

            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            Text(subtitle)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SimilarEventCard: View {
    let index: Int
    let category: EventCategory

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(category.color.opacity(0.3))
                .frame(width: 200, height: 80)
                .overlay(
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 24))
                        .foregroundColor(category.color)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text("Similar Event \(index + 1)")
                    .font(.system(size: 14, weight: .semibold))
                    .lineLimit(1)

                Text("Event description...")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 200)
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TicketPurchaseSheet: View {
    let event: Event
    @Binding var selectedTickets: Int
    let onPurchase: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Register for Event")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 16) {
                    Text("Number of tickets")
                        .font(.headline)

                    HStack {
                        Button {
                            if selectedTickets > 1 {
                                selectedTickets -= 1
                            }
                        } label: {
                            Image(systemName: "minus")
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        .disabled(selectedTickets <= 1)

                        Text("\(selectedTickets)")
                            .font(.title)
                            .fontWeight(.bold)
                            .frame(minWidth: 50)

                        Button {
                            if selectedTickets < 10 {
                                selectedTickets += 1
                            }
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 44, height: 44)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        .disabled(selectedTickets >= 10)

                        Spacer()

                        Text("Total: $\(Int(event.price * Double(selectedTickets)))")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                }

                Spacer()

                HStack(spacing: 12) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    .frame(maxWidth: .infinity)

                    Button("Purchase") {
                        onPurchase()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(20)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NavigationStack {
        EventDetailScreen(
            event: Event(
                id: "1",
                title: "Flutter Dev Conference",
                description: "Annual Flutter developer conference with latest updates and best practices.",
                date: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                location: "San Francisco, CA",
                category: .technology,
                attendees: 250,
                price: 299.0,
                imageUrl: "https://via.placeholder.com/300x200"
            )
        )
    }
}