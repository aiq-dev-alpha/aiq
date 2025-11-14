import SwiftUI

struct WishlistView: View {
    @State private var wishlistItems = [
        WishlistItem(id: "1", name: "Premium Cotton T-Shirt", price: 29.99, originalPrice: 39.99, inStock: true, rating: 4.5),
        WishlistItem(id: "2", name: "Wireless Headphones", price: 89.99, originalPrice: nil, inStock: true, rating: 4.8),
        WishlistItem(id: "3", name: "Designer Jacket", price: 199.99, originalPrice: 249.99, inStock: false, rating: 4.2),
    ]

    var body: some View {
        NavigationView {
            if wishlistItems.isEmpty {
                EmptyWishlistView()
            } else {
                VStack {
                    List {
                        ForEach(wishlistItems.indices, id: \.self) { index in
                            WishlistItemRow(item: $wishlistItems[index]) {
                                wishlistItems.remove(at: index)
                            }
                        }
                    }

                    // Bottom Actions
                    HStack {
                        Button("Share Wishlist") {
                            // Share wishlist
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)

                        Button("Add All to Cart") {
                            // Add all in-stock items to cart
                        }
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pink)
                        .cornerRadius(8)
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Wishlist (\(wishlistItems.count))")
    }
}

struct WishlistItem {
    let id: String
    let name: String
    let price: Double
    let originalPrice: Double?
    let inStock: Bool
    let rating: Double
}

struct WishlistItemRow: View {
    @Binding var item: WishlistItem
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .overlay(
                    item.originalPrice != nil ?
                    VStack {
                        Spacer()
                        HStack {
                            Text("SALE")
                                .font(.caption2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(Color.red)
                                .cornerRadius(4)
                            Spacer()
                        }
                    }.padding(4) : nil
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)

                HStack {
                    HStack(spacing: 2) {
                        ForEach(0..<5) { index in
                            Image(systemName: Double(index) < item.rating ? "star.fill" : "star")
                                .foregroundColor(.yellow)
                                .font(.caption)
                        }
                    }
                    Text(String(format: "%.1f", item.rating))
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("$\(item.price, specifier: "%.2f")")
                        .font(.headline)
                        .foregroundColor(.blue)

                    if let originalPrice = item.originalPrice {
                        Text("$\(originalPrice, specifier: "%.2f")")
                            .font(.caption)
                            .strikethrough()
                            .foregroundColor(.gray)
                    }
                }

                Text(item.inStock ? "In Stock" : "Out of Stock")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(item.inStock ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .foregroundColor(item.inStock ? .green : .red)
                    .cornerRadius(4)

                HStack {
                    Button(item.inStock ? "Add to Cart" : "Notify Me") {
                        // Add to cart or notify
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(item.inStock ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                    .foregroundColor(item.inStock ? .blue : .gray)
                    .cornerRadius(6)

                    Button("View") {
                        // View product details
                    }
                    .font(.caption)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.gray)
                    .cornerRadius(6)
                }
            }

            Spacer()

            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 8)
    }
}

struct EmptyWishlistView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text("Your wishlist is empty")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Save items you love for later")
                    .foregroundColor(.gray)
            }

            Button {
                // Start shopping
            } label: {
                Text("Start Shopping")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.pink)
                    .cornerRadius(8)
            }
        }
    }
}

struct WishlistView_Previews: PreviewProvider {
    static var previews: some View {
        WishlistView()
    }
}