import SwiftUI

struct ProductDetailView: View {
    @State private var selectedImageIndex = 0
    @State private var selectedSize = "M"
    @State private var selectedColor = "Red"
    @State private var quantity = 1
    @State private var isFavorite = false

    let sizes = ["XS", "S", "M", "L", "XL"]
    let colors = ["Red", "Blue", "Green", "Black", "White"]
    let productImages = Array(0..<5)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Product Images
                TabView(selection: $selectedImageIndex) {
                    ForEach(productImages.indices, id: \.self) { index in
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 60))
                                    .foregroundColor(.gray)
                            )
                            .tag(index)
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())

                // Image Thumbnails
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(productImages.indices, id: \.self) { index in
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                )
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedImageIndex == index ? Color.blue : Color.clear, lineWidth: 2)
                                )
                                .onTapGesture {
                                    selectedImageIndex = index
                                }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)

                VStack(alignment: .leading, spacing: 16) {
                    // Product Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Premium Cotton T-Shirt")
                            .font(.title2)
                            .fontWeight(.bold)

                        HStack {
                            HStack(spacing: 2) {
                                ForEach(0..<5) { index in
                                    Image(systemName: index < 4 ? "star.fill" : "star")
                                        .foregroundColor(.yellow)
                                        .font(.caption)
                                }
                            }
                            Text("4.5 (120 reviews)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        HStack(alignment: .bottom) {
                            Text("$29.99")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)

                            Text("$39.99")
                                .font(.body)
                                .strikethrough()
                                .foregroundColor(.gray)

                            Text("25% OFF")
                                .font(.caption)
                                .fontWeight(.bold)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(4)
                        }
                    }

                    // Size Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Size")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                            ForEach(sizes, id: \.self) { size in
                                Button(size) {
                                    selectedSize = size
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedSize == size ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .foregroundColor(selectedSize == size ? .blue : .primary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedSize == size ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                            }
                        }
                    }

                    // Color Selection
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Color")
                            .font(.headline)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 12) {
                            ForEach(colors, id: \.self) { color in
                                HStack {
                                    Circle()
                                        .fill(colorFromName(color))
                                        .frame(width: 16, height: 16)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                    Text(color)
                                    Spacer()
                                }
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(selectedColor == color ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
                                .foregroundColor(selectedColor == color ? .blue : .primary)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedColor == color ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
                                )
                                .onTapGesture {
                                    selectedColor = color
                                }
                            }
                        }
                    }

                    // Quantity
                    HStack {
                        Text("Quantity")
                            .font(.headline)

                        Spacer()

                        HStack {
                            Button {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(quantity > 1 ? .blue : .gray)
                            }

                            Text("\(quantity)")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)

                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus.circle")
                                    .foregroundColor(.blue)
                            }
                        }
                    }

                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)

                        Text("This premium cotton t-shirt is made from 100% organic cotton with a comfortable fit. Perfect for casual wear and everyday comfort. Machine washable and available in multiple colors and sizes.")
                            .foregroundColor(.gray)
                    }

                    // Features
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Features")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 4) {
                            FeatureRow(text: "100% Organic Cotton")
                            FeatureRow(text: "Machine Washable")
                            FeatureRow(text: "Comfortable Fit")
                            FeatureRow(text: "Sustainable Production")
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button {
                        // Share
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }

                    Button {
                        isFavorite.toggle()
                    } label: {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .primary)
                    }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            // Add to Cart Button
            HStack {
                Button {
                    // Add to cart
                } label: {
                    Text("ADD TO CART - $\(String(format: "%.2f", 29.99 * Double(quantity)))")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }

                Button {
                    // Buy now
                } label: {
                    Text("BUY NOW")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange)
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .shadow(radius: 5)
        }
    }

    func colorFromName(_ name: String) -> Color {
        switch name.lowercased() {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "black": return .black
        case "white": return .gray
        default: return .gray
        }
    }
}

struct FeatureRow: View {
    let text: String

    var body: some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(text)
                .foregroundColor(.gray)
        }
    }
}

struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductDetailView()
        }
    }
}