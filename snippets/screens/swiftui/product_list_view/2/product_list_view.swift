import SwiftUI

struct ProductListView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var isGridView = true
    @State private var selectedSort = "Featured"

    let categories = ["All", "Electronics", "Fashion", "Home", "Sports"]
    let sortOptions = ["Featured", "Price: Low to High", "Price: High to Low", "Newest"]

    var body: some View {
        NavigationView {
            VStack {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search products...", text: $searchText)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal)

                // Filter Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(categories, id: \.self) { category in
                            Button(category) {
                                selectedCategory = category
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color.blue : Color.gray.opacity(0.2))
                            .foregroundColor(selectedCategory == category ? .white : .primary)
                            .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                }

                // Products Grid/List
                if isGridView {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                        ForEach(1...20, id: \.self) { index in
                            ProductCardView(index: index)
                        }
                    }
                    .padding()
                } else {
                    LazyVStack {
                        ForEach(1...20, id: \.self) { index in
                            ProductListItemView(index: index)
                        }
                    }
                    .padding()
                }

                Spacer()
            }
            .navigationTitle("Products")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            isGridView.toggle()
                        } label: {
                            Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                        }

                        Button {
                            // Navigate to cart
                        } label: {
                            Image(systemName: "cart")
                        }
                    }
                }
            }
        }
    }
}

struct ProductCardView: View {
    let index: Int

    var body: some View {
        VStack(alignment: .leading) {
            // Product Image
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 120)
                .overlay(
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                )
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text("Product \(index)")
                    .font(.headline)
                    .lineLimit(2)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("4.5")
                        .font(.caption)
                    Text("(120)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                HStack {
                    Text("$\(index * 10).99")
                        .font(.headline)
                        .foregroundColor(.red)

                    Spacer()

                    Button {
                        // Add to cart
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.blue)
                            .cornerRadius(6)
                    }
                }
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct ProductListItemView: View {
    let index: Int

    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(
                    Image(systemName: "photo")
                        .foregroundColor(.gray)
                )
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text("Product \(index)")
                    .font(.headline)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.caption)
                    Text("4.5 (120)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }

                Text("$\(index * 10).99")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }

            Spacer()

            Button {
                // Add to cart
            } label: {
                Image(systemName: "cart.badge.plus")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 1)
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}