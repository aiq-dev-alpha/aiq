import SwiftUI

struct FilterScreen: View {
    let initialFilters: [String: Any]?

    @State private var selectedCategories = Set<String>()
    @State private var selectedTags = Set<String>()
    @State private var selectedFileTypes = Set<String>()
    @State private var priceRange: ClosedRange<Float> = 0...1000
    @State private var ratingRange: ClosedRange<Float> = 0...5
    @State private var selectedSortBy = "relevance"
    @State private var inStock = false
    @State private var freeShipping = false
    @State private var onSale = false
    @State private var fromDate: Date?
    @State private var toDate: Date?

    @State private var showFromDatePicker = false
    @State private var showToDatePicker = false

    @Environment(\.dismiss) private var dismiss

    private let availableCategories = [
        "Electronics", "Clothing", "Books", "Home & Garden",
        "Sports", "Beauty", "Automotive", "Toys"
    ]

    private let availableTags = [
        "Popular", "Trending", "New", "Featured",
        "Best Seller", "Limited Edition", "Premium", "Eco-Friendly"
    ]

    private let availableFileTypes = [
        "PDF", "DOC", "XLS", "PPT", "IMG", "VID", "AUD", "ZIP"
    ]

    private let sortOptions = [
        ("relevance", "Relevance"),
        ("price_low", "Price: Low to High"),
        ("price_high", "Price: High to Low"),
        ("rating", "Highest Rated"),
        ("newest", "Newest"),
        ("popularity", "Most Popular")
    ]

    init(initialFilters: [String: Any]? = nil) {
        self.initialFilters = initialFilters
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with filter count
                HStack {
                    Text("Filters")
                        .font(.title2)
                        .fontWeight(.bold)

                    if activeFiltersCount > 0 {
                        Text("\(activeFiltersCount)")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }

                    Spacer()

                    Button("Reset") {
                        resetFilters()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)

                ScrollView {
                    LazyVStack(spacing: 24) {
                        // Categories
                        filterSection(title: "Categories") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(availableCategories, id: \.self) { category in
                                    filterChip(category, isSelected: selectedCategories.contains(category)) {
                                        toggleSelection(category, in: &selectedCategories)
                                    }
                                }
                            }
                        }

                        // Tags
                        filterSection(title: "Tags") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                                ForEach(availableTags, id: \.self) { tag in
                                    filterChip(tag, isSelected: selectedTags.contains(tag)) {
                                        toggleSelection(tag, in: &selectedTags)
                                    }
                                }
                            }
                        }

                        // File Types
                        filterSection(title: "File Types") {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                                ForEach(availableFileTypes, id: \.self) { type in
                                    filterChip(type, isSelected: selectedFileTypes.contains(type)) {
                                        toggleSelection(type, in: &selectedFileTypes)
                                    }
                                }
                            }
                        }

                        // Price Range
                        filterSection(title: "Price Range ($\(Int(priceRange.lowerBound)) - $\(Int(priceRange.upperBound)))") {
                            RangeSlider(range: $priceRange, bounds: 0...1000, step: 50)
                        }

                        // Rating Range
                        filterSection(title: "Minimum Rating (\(String(format: "%.1f", ratingRange.lowerBound)) stars)") {
                            Slider(
                                value: Binding(
                                    get: { ratingRange.lowerBound },
                                    set: { ratingRange = $0...ratingRange.upperBound }
                                ),
                                in: 0...5,
                                step: 0.5
                            )
                        }

                        // Sort By
                        filterSection(title: "Sort By") {
                            Picker("Sort By", selection: $selectedSortBy) {
                                ForEach(sortOptions, id: \.0) { option in
                                    Text(option.1).tag(option.0)
                                }
                            }
                            .pickerStyle(.menu)
                        }

                        // Options
                        filterSection(title: "Options") {
                            VStack(alignment: .leading, spacing: 16) {
                                Toggle("In Stock Only", isOn: $inStock)
                                Toggle("Free Shipping", isOn: $freeShipping)
                                Toggle("On Sale", isOn: $onSale)
                            }
                        }

                        // Date Range
                        filterSection(title: "Date Range") {
                            VStack(spacing: 12) {
                                Button {
                                    showFromDatePicker = true
                                } label: {
                                    HStack {
                                        Text(fromDate == nil ? "From Date" : "From: \(formattedDate(fromDate!))")
                                        Spacer()
                                        Image(systemName: "calendar")
                                    }
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }

                                Button {
                                    showToDatePicker = true
                                } label: {
                                    HStack {
                                        Text(toDate == nil ? "To Date" : "To: \(formattedDate(toDate!))")
                                        Spacer()
                                        Image(systemName: "calendar")
                                    }
                                    .foregroundColor(.primary)
                                    .padding()
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                }
                            }
                        }

                        // Space for apply button
                        Color.clear.frame(height: 100)
                    }
                    .padding(.horizontal, 20)
                }

                // Apply Button
                VStack(spacing: 0) {
                    Divider()

                    Button {
                        applyFilters()
                    } label: {
                        Text(activeFiltersCount > 0 ? "Apply \(activeFiltersCount) Filters" : "Apply Filters")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
                .background(Color(.systemBackground))
            }
            .navigationBarHidden(true)
        }
        .onAppear {
            loadInitialFilters()
        }
        .sheet(isPresented: $showFromDatePicker) {
            DatePickerSheet(selectedDate: $fromDate, title: "From Date")
        }
        .sheet(isPresented: $showToDatePicker) {
            DatePickerSheet(selectedDate: $toDate, title: "To Date")
        }
    }

    private var activeFiltersCount: Int {
        var count = 0
        count += selectedCategories.count
        count += selectedTags.count
        count += selectedFileTypes.count
        if priceRange.lowerBound > 0 || priceRange.upperBound < 1000 { count += 1 }
        if ratingRange.lowerBound > 0 || ratingRange.upperBound < 5 { count += 1 }
        if selectedSortBy != "relevance" { count += 1 }
        if inStock { count += 1 }
        if freeShipping { count += 1 }
        if onSale { count += 1 }
        if fromDate != nil || toDate != nil { count += 1 }
        return count
    }

    private func filterSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)

            content()
        }
    }

    private func filterChip(_ text: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Text(text)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(isSelected ? Color.accentColor : Color(.systemGray6))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
        .buttonStyle(.plain)
    }

    private func toggleSelection<T: Hashable>(_ item: T, in set: inout Set<T>) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
    }

    private func loadInitialFilters() {
        guard let filters = initialFilters else { return }

        if let categories = filters["categories"] as? [String] {
            selectedCategories = Set(categories)
        }
        if let tags = filters["tags"] as? [String] {
            selectedTags = Set(tags)
        }
        if let fileTypes = filters["fileTypes"] as? [String] {
            selectedFileTypes = Set(fileTypes)
        }
        if let priceMin = filters["priceMin"] as? Float,
           let priceMax = filters["priceMax"] as? Float {
            priceRange = priceMin...priceMax
        }
        if let ratingMin = filters["ratingMin"] as? Float,
           let ratingMax = filters["ratingMax"] as? Float {
            ratingRange = ratingMin...ratingMax
        }
        if let sortBy = filters["sortBy"] as? String {
            selectedSortBy = sortBy
        }
        inStock = filters["inStock"] as? Bool ?? false
        freeShipping = filters["freeShipping"] as? Bool ?? false
        onSale = filters["onSale"] as? Bool ?? false
        fromDate = filters["fromDate"] as? Date
        toDate = filters["toDate"] as? Date
    }

    private func resetFilters() {
        selectedCategories.removeAll()
        selectedTags.removeAll()
        selectedFileTypes.removeAll()
        priceRange = 0...1000
        ratingRange = 0...5
        selectedSortBy = "relevance"
        inStock = false
        freeShipping = false
        onSale = false
        fromDate = nil
        toDate = nil
    }

    private func applyFilters() {
        let filters: [String: Any] = [
            "categories": Array(selectedCategories),
            "tags": Array(selectedTags),
            "fileTypes": Array(selectedFileTypes),
            "priceMin": priceRange.lowerBound,
            "priceMax": priceRange.upperBound,
            "ratingMin": ratingRange.lowerBound,
            "ratingMax": ratingRange.upperBound,
            "sortBy": selectedSortBy,
            "inStock": inStock,
            "freeShipping": freeShipping,
            "onSale": onSale,
            "fromDate": fromDate as Any,
            "toDate": toDate as Any,
        ]

        // Return filters to parent view
        dismiss()
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Float>
    let bounds: ClosedRange<Float>
    let step: Float

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                VStack {
                    Text("Min")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(
                        value: Binding(
                            get: { range.lowerBound },
                            set: { newValue in
                                let steppedValue = round(newValue / step) * step
                                range = steppedValue...max(steppedValue, range.upperBound)
                            }
                        ),
                        in: bounds,
                        step: step
                    )
                }

                VStack {
                    Text("Max")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Slider(
                        value: Binding(
                            get: { range.upperBound },
                            set: { newValue in
                                let steppedValue = round(newValue / step) * step
                                range = min(steppedValue, range.lowerBound)...steppedValue
                            }
                        ),
                        in: bounds,
                        step: step
                    )
                }
            }
        }
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date?
    let title: String
    @State private var tempDate = Date()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack {
                DatePicker(title, selection: $tempDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()

                Spacer()
            }
            .padding()
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        selectedDate = tempDate
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            tempDate = selectedDate ?? Date()
        }
    }
}

#Preview {
    FilterScreen()
}