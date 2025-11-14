import SwiftUI

struct CartView: View {
    @State private var cartItems = [
        CartItem(id: "1", name: "Premium Cotton T-Shirt", price: 29.99, quantity: 2, size: "M", color: "Blue"),
        CartItem(id: "2", name: "Wireless Headphones", price: 89.99, quantity: 1, size: nil, color: "Black"),
    ]

    var subtotal: Double {
        cartItems.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    let shipping = 9.99
    var tax: Double { subtotal * 0.08 }
    var total: Double { subtotal + shipping + tax }

    var body: some View {
        NavigationView {
            if cartItems.isEmpty {
                EmptyCartView()
            } else {
                VStack {
                    List {
                        ForEach(cartItems.indices, id: \.self) { index in
                            CartItemRow(item: $cartItems[index]) {
                                cartItems.remove(at: index)
                            }
                        }
                    }

                    // Order Summary
                    VStack(spacing: 8) {
                        HStack {
                            TextField("Promo code", text: .constant(""))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Apply") {
                                // Apply promo code
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)

                        VStack {
                            SummaryRow(label: "Subtotal", value: "$\(subtotal, specifier: "%.2f")")
                            SummaryRow(label: "Shipping", value: "$\(shipping, specifier: "%.2f")")
                            SummaryRow(label: "Tax", value: "$\(tax, specifier: "%.2f")")
                            Divider()
                            SummaryRow(label: "Total", value: "$\(total, specifier: "%.2f")", isTotal: true)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))

                        Button {
                            // Proceed to checkout
                        } label: {
                            Text("PROCEED TO CHECKOUT")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Shopping Cart (\(cartItems.count))")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !cartItems.isEmpty {
                    Button("Clear All") {
                        cartItems.removeAll()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

struct CartItem {
    let id: String
    let name: String
    let price: Double
    var quantity: Int
    let size: String?
    let color: String?
}

struct CartItemRow: View {
    @Binding var item: CartItem
    let onRemove: () -> Void

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 60, height: 60)
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .lineLimit(2)

                if let size = item.size, let color = item.color {
                    Text("\(size) • \(color)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text("$\(item.price, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.blue)
            }

            Spacer()

            VStack {
                HStack {
                    Button {
                        if item.quantity > 1 {
                            item.quantity -= 1
                        }
                    } label: {
                        Image(systemName: "minus.circle")
                            .foregroundColor(item.quantity > 1 ? .blue : .gray)
                    }

                    Text("\(item.quantity)")
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)

                    Button {
                        item.quantity += 1
                    } label: {
                        Image(systemName: "plus.circle")
                            .foregroundColor(.blue)
                    }
                }

                HStack {
                    Button {
                        // Add to wishlist
                    } label: {
                        Image(systemName: "heart")
                            .foregroundColor(.gray)
                    }

                    Button {
                        onRemove()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

struct SummaryRow: View {
    let label: String
    let value: String
    var isTotal: Bool = false

    var body: some View {
        HStack {
            Text(label)
                .font(isTotal ? .headline : .body)
                .fontWeight(isTotal ? .bold : .regular)

            Spacer()

            Text(value)
                .font(isTotal ? .headline : .body)
                .fontWeight(isTotal ? .bold : .semibold)
                .foregroundColor(isTotal ? .blue : .primary)
        }
    }
}

struct EmptyCartView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "cart")
                .font(.system(size: 80))
                .foregroundColor(.gray)

            VStack(spacing: 8) {
                Text("Your cart is empty")
                    .font(.title2)
                    .fontWeight(.bold)

                Text("Add some items to get started")
                    .foregroundColor(.gray)
            }

            Button {
                // Continue shopping
            } label: {
                Text("Continue Shopping")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        CartView()
    }
}