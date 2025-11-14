import SwiftUI

struct RestaurantDetailScreen: View {
    let restaurant: Restaurant
    @State private var selectedTab = 0
    @State private var isFavorite = false
    @State private var cartItems: [CartItem] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Restaurant Header
                RestaurantHeaderView(restaurant: restaurant, isFavorite: $isFavorite)

                // Restaurant Info Cards
                RestaurantInfoCardsView(restaurant: restaurant)

                // Tab Bar
                CustomTabBar(selectedTab: $selectedTab)

                // Tab Content
                Group {
                    switch selectedTab {
                    case 0: MenuTabView(restaurant: restaurant, cartItems: $cartItems)
                    case 1: ReviewsTabView(restaurant: restaurant)
                    case 2: PhotosTabView()
                    case 3: InfoTabView(restaurant: restaurant)
                    default: MenuTabView(restaurant: restaurant, cartItems: $cartItems)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            if !cartItems.isEmpty {
                CartSummaryView(cartItems: cartItems, restaurant: restaurant)
            }
        }
    }
}

struct RestaurantHeaderView: View {
    let restaurant: Restaurant
    @Binding var isFavorite: Bool

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 0)
                .fill(restaurant.cuisineColor.gradient)
                .frame(height: 200)
                .overlay(
                    VStack {
                        if !restaurant.isOpen {
                            VStack {
                                Image(systemName: "clock")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("Currently Closed")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("Opens at 11:00 AM")
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.opacity(0.5))
                        }
                    }
                )

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    if restaurant.isFeatured {
                        Text("Featured")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }

                    Text(restaurant.name)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(restaurant.cuisine)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }

                Spacer()
            }
            .padding(20)
        }
    }
}

struct RestaurantInfoCardsView: View {
    let restaurant: Restaurant

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
            InfoCard(icon: "star.fill", iconColor: .yellow, title: "Rating", subtitle: String(format: "%.1f (%d)", restaurant.rating, restaurant.reviewCount))
            InfoCard(icon: "clock", iconColor: .green, title: "Delivery", subtitle: restaurant.deliveryTime)
            InfoCard(icon: "dollarsign.circle", iconColor: .blue, title: "Fee", subtitle: "$\(restaurant.deliveryFee, specifier: "%.2f")")
        }
        .padding()
    }
}

struct InfoCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(iconColor)
                .font(.title2)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            ForEach(["Menu", "Reviews", "Photos", "Info"].indices, id: \.self) { index in
                Button {
                    selectedTab = index
                } label: {
                    Text(["Menu", "Reviews", "Photos", "Info"][index])
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

struct MenuTabView: View {
    let restaurant: Restaurant
    @Binding var cartItems: [CartItem]

    let menuItems = [
        MenuItem(id: "1", name: "Margherita Pizza", description: "Fresh mozzarella, tomato sauce, basil", price: 16.99, category: "Main Courses"),
        MenuItem(id: "2", name: "Caesar Salad", description: "Romaine lettuce, parmesan, croutons", price: 12.99, category: "Appetizers"),
        MenuItem(id: "3", name: "Tiramisu", description: "Classic Italian dessert with mascarpone", price: 8.99, category: "Desserts")
    ]

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 16) {
            ForEach(groupedMenuItems.keys.sorted(), id: \.self) { category in
                VStack(alignment: .leading, spacing: 12) {
                    Text(category)
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.horizontal)

                    ForEach(groupedMenuItems[category] ?? []) { item in
                        MenuItemRow(item: item, restaurant: restaurant, cartItems: $cartItems)
                    }
                }
            }
        }
        .padding(.vertical)
    }

    private var groupedMenuItems: [String: [MenuItem]] {
        Dictionary(grouping: menuItems, by: { $0.category })
    }
}

struct MenuItemRow: View {
    let item: MenuItem
    let restaurant: Restaurant
    @Binding var cartItems: [CartItem]

    var body: some View {
        HStack(spacing: 16) {
            // Item Image Placeholder
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(.systemGray5))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )

            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.system(size: 16, weight: .semibold))

                Text(item.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.green)

                    Spacer()

                    Button("Add to Cart") {
                        addToCart(item)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                    .disabled(!restaurant.isOpen)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
    }

    private func addToCart(_ item: MenuItem) {
        if let index = cartItems.firstIndex(where: { $0.menuItem.id == item.id }) {
            cartItems[index].quantity += 1
        } else {
            cartItems.append(CartItem(menuItem: item, quantity: 1))
        }
    }
}

struct ReviewsTabView: View {
    let restaurant: Restaurant

    var body: some View {
        LazyVStack(spacing: 16) {
            // Rating Summary
            VStack(spacing: 16) {
                HStack {
                    Text(String(format: "%.1f", restaurant.rating))
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    VStack(alignment: .leading) {
                        HStack {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(restaurant.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                                    .font(.caption)
                            }
                        }
                        Text("\(restaurant.reviewCount) reviews")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Sample Reviews
            ForEach(0..<3) { index in
                ReviewRow(index: index)
            }
        }
        .padding()
    }
}

struct ReviewRow: View {
    let index: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("U")
                            .fontWeight(.semibold)
                    )

                VStack(alignment: .leading) {
                    Text("User \(index + 1)")
                        .fontWeight(.semibold)

                    HStack {
                        ForEach(0..<5) { starIndex in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                        Text("2 days ago")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()
            }

            Text("Great food and excellent service! Would definitely recommend to anyone looking for authentic cuisine.")
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PhotosTabView: View {
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
            ForEach(0..<6) { _ in
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(height: 120)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.title)
                    )
            }
        }
        .padding()
    }
}

struct InfoTabView: View {
    let restaurant: Restaurant

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Hours
            VStack(alignment: .leading, spacing: 12) {
                Text("Hours")
                    .font(.headline)
                    .fontWeight(.bold)

                VStack(spacing: 8) {
                    ForEach(["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"], id: \.self) { day in
                        HStack {
                            Text(day)
                            Spacer()
                            Text("11:00 AM - 10:00 PM")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            // Contact Info
            VStack(alignment: .leading, spacing: 12) {
                Text("Contact")
                    .font(.headline)
                    .fontWeight(.bold)

                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.red)
                        Text(restaurant.address)
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
                        Text("+1 555-0123")
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
        }
        .padding()
    }
}

struct CartSummaryView: View {
    let cartItems: [CartItem]
    let restaurant: Restaurant

    var totalPrice: Double {
        cartItems.reduce(0) { $0 + ($1.menuItem.price * Double($1.quantity)) }
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(cartItems.reduce(0) { $0 + $1.quantity }) items")
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("$\(totalPrice, specifier: "%.2f")")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
            }

            Spacer()

            Button("View Cart") {
                // View cart
            }
            .buttonStyle(.borderedProminent)
            .tint(restaurant.cuisineColor)
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: -2)
    }
}

struct MenuItem: Identifiable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let category: String
}

struct CartItem {
    let menuItem: MenuItem
    var quantity: Int
}

#Preview {
    NavigationStack {
        RestaurantDetailScreen(
            restaurant: Restaurant(
                id: "1",
                name: "The Golden Spoon",
                cuisine: "Italian",
                rating: 4.8,
                reviewCount: 324,
                priceRange: .expensive,
                deliveryTime: "25-40 min",
                deliveryFee: 3.99,
                distance: 0.8,
                isOpen: true,
                isFeatured: true,
                address: "123 Main St, Downtown"
            )
        )
    }
}