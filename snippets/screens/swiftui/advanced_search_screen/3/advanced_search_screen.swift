import SwiftUI

struct AdvancedSearchScreen: View {
    @State private var keywords = ""
    @State private var exactPhrase = ""
    @State private var excludeWords = ""
    @State private var author = ""
    @State private var domain = ""

    @State private var selectedFileType = "any"
    @State private var selectedTimeRange = "any"
    @State private var selectedSortBy = "relevance"
    @State private var safeSearch = true
    @State private var customDateRange: ClosedRange<Date>?
    @State private var sizeRange: ClosedRange<Float> = 0...100

    @State private var selectedCategories = Set<String>()
    @State private var selectedLanguages = Set<String>()

    @State private var showDatePicker = false

    private let fileTypes = ["any", "pdf", "doc", "image", "video", "audio"]
    private let timeRanges = ["any", "hour", "day", "week", "month", "year", "custom"]
    private let sortOptions = ["relevance", "date", "popularity", "rating"]

    private let categories = ["Technology", "Science", "Business", "Health", "Entertainment", "Sports", "Politics", "Education"]
    private let languages = ["English", "Spanish", "French", "German", "Chinese", "Japanese", "Arabic", "Portuguese"]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section("Keywords") {
                    VStack(alignment: .leading, spacing: 12) {
                        TextField("All of these words", text: $keywords)
                            .textFieldStyle(.roundedBorder)

                        TextField("This exact phrase", text: $exactPhrase)
                            .textFieldStyle(.roundedBorder)

                        TextField("None of these words", text: $excludeWords)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section("Content Filters") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("File Type", selection: $selectedFileType) {
                            ForEach(fileTypes, id: \.self) { type in
                                Text(type.capitalized).tag(type)
                            }
                        }
                        .pickerStyle(.menu)

                        TextField("Author", text: $author)
                            .textFieldStyle(.roundedBorder)

                        TextField("Site or Domain", text: $domain)
                            .textFieldStyle(.roundedBorder)
                    }
                }

                Section("Categories") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(categories, id: \.self) { category in
                            Button {
                                toggleSelection(category, in: &selectedCategories)
                            } label: {
                                Text(category)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedCategories.contains(category) ?
                                        Color.accentColor : Color(.systemGray6)
                                    )
                                    .foregroundColor(
                                        selectedCategories.contains(category) ?
                                        .white : .primary
                                    )
                                    .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Time Range") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Time Range", selection: $selectedTimeRange) {
                            Text("Any time").tag("any")
                            Text("Past hour").tag("hour")
                            Text("Past 24 hours").tag("day")
                            Text("Past week").tag("week")
                            Text("Past month").tag("month")
                            Text("Past year").tag("year")
                            Text("Custom range").tag("custom")
                        }
                        .pickerStyle(.menu)

                        if selectedTimeRange == "custom" {
                            Button {
                                showDatePicker = true
                            } label: {
                                HStack {
                                    Text(customDateRange?.description ?? "Select date range")
                                    Spacer()
                                    Image(systemName: "calendar")
                                }
                            }
                            .foregroundColor(.primary)
                        }
                    }
                }

                Section("File Size (MB)") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(Int(sizeRange.lowerBound)) MB - \(Int(sizeRange.upperBound)) MB")
                            .font(.caption)
                            .foregroundColor(.secondary)

                        RangeSlider(range: $sizeRange, bounds: 0...100)
                    }
                }

                Section("Languages") {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 8) {
                        ForEach(languages, id: \.self) { language in
                            Button {
                                toggleSelection(language, in: &selectedLanguages)
                            } label: {
                                Text(language)
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedLanguages.contains(language) ?
                                        Color.accentColor : Color(.systemGray6)
                                    )
                                    .foregroundColor(
                                        selectedLanguages.contains(language) ?
                                        .white : .primary
                                    )
                                    .cornerRadius(16)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section("Options") {
                    VStack(alignment: .leading, spacing: 12) {
                        Picker("Sort by", selection: $selectedSortBy) {
                            ForEach(sortOptions, id: \.self) { option in
                                Text(option.capitalized).tag(option)
                            }
                        }
                        .pickerStyle(.menu)

                        Toggle("Safe Search", isOn: $safeSearch)
                    }
                }
            }
            .navigationTitle("Advanced Search")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        resetFilters()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Search") {
                        performAdvancedSearch()
                    }
                    .fontWeight(.semibold)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DateRangePicker(range: $customDateRange)
            }
        }
    }

    private func toggleSelection<T: Hashable>(_ item: T, in set: inout Set<T>) {
        if set.contains(item) {
            set.remove(item)
        } else {
            set.insert(item)
        }
    }

    private func resetFilters() {
        keywords = ""
        exactPhrase = ""
        excludeWords = ""
        author = ""
        domain = ""
        selectedFileType = "any"
        selectedTimeRange = "any"
        selectedSortBy = "relevance"
        safeSearch = true
        customDateRange = nil
        sizeRange = 0...100
        selectedCategories.removeAll()
        selectedLanguages.removeAll()
    }

    private func performAdvancedSearch() {
        let searchParams: [String: Any] = [
            "keywords": keywords,
            "exactPhrase": exactPhrase,
            "excludeWords": excludeWords,
            "author": author,
            "domain": domain,
            "fileType": selectedFileType,
            "timeRange": selectedTimeRange,
            "customDateRange": customDateRange as Any,
            "sortBy": selectedSortBy,
            "safeSearch": safeSearch,
            "sizeRange": sizeRange,
            "categories": Array(selectedCategories),
            "languages": Array(selectedLanguages),
        ]

        // Navigate to search results with parameters
        dismiss()
    }
}

struct RangeSlider: View {
    @Binding var range: ClosedRange<Float>
    let bounds: ClosedRange<Float>

    var body: some View {
        HStack {
            Slider(value: Binding(
                get: { range.lowerBound },
                set: { newValue in
                    range = newValue...max(newValue, range.upperBound)
                }
            ), in: bounds)

            Slider(value: Binding(
                get: { range.upperBound },
                set: { newValue in
                    range = min(newValue, range.lowerBound)...newValue
                }
            ), in: bounds)
        }
    }
}

struct DateRangePicker: View {
    @Binding var range: ClosedRange<Date>?
    @State private var startDate = Date()
    @State private var endDate = Date()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("From", selection: $startDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)

                DatePicker("To", selection: $endDate, displayedComponents: .date)
                    .datePickerStyle(.wheel)
            }
            .padding()
            .navigationTitle("Select Date Range")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        range = startDate...endDate
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AdvancedSearchScreen()
}