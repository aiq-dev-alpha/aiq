import SwiftUI

struct NotesListScreen: View {
    @State private var searchText = ""
    @State private var isGridView = true
    @State private var showingNewNote = false
    @State private var selectedCategory: NoteCategory?

    @State private var notes = [
        Note(id: "1", title: "Meeting Notes - Q4 Planning", content: "Discussed upcoming projects...", category: .work, color: .blue, lastModified: Date(), isPinned: true),
        Note(id: "2", title: "Travel Itinerary - Europe Trip", content: "Day 1: London...", category: .personal, color: .green, lastModified: Date().addingTimeInterval(-86400), isPinned: false),
        Note(id: "3", title: "Recipe: Chocolate Chip Cookies", content: "Ingredients: 2 cups flour...", category: .personal, color: .orange, lastModified: Date().addingTimeInterval(-259200), isPinned: false),
        Note(id: "4", title: "SwiftUI Development Tips", content: "Key concepts to remember...", category: .learning, color: .purple, lastModified: Date().addingTimeInterval(-432000), isPinned: true),
        Note(id: "5", title: "Book Ideas", content: "Potential book topics...", category: .creative, color: .pink, lastModified: Date().addingTimeInterval(-604800), isPinned: false)
    ]

    var filteredNotes: [Note] {
        var filtered = notes

        if !searchText.isEmpty {
            filtered = filtered.filter { note in
                note.title.localizedCaseInsensitiveContains(searchText) ||
                note.content.localizedCaseInsensitiveContains(searchText)
            }
        }

        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }

        return filtered.sorted { first, second in
            if first.isPinned && !second.isPinned { return true }
            if !first.isPinned && second.isPinned { return false }
            return first.lastModified > second.lastModified
        }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.top, 8)

                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        CategoryFilterChip(category: nil, selectedCategory: $selectedCategory, title: "All")

                        ForEach(NoteCategory.allCases, id: \.self) { category in
                            CategoryFilterChip(category: category, selectedCategory: $selectedCategory, title: category.rawValue.capitalized)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)

                if filteredNotes.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "note.text")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))
                        Text(searchText.isEmpty ? "No notes yet" : "No notes found")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        if searchText.isEmpty {
                            Button("Create Note") {
                                showingNewNote = true
                            }
                            .buttonStyle(.bordered)
                        }
                        Spacer()
                    }
                } else {
                    if isGridView {
                        NotesGridView(notes: filteredNotes)
                    } else {
                        NotesListView(notes: filteredNotes)
                    }
                }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isGridView.toggle()
                    } label: {
                        Image(systemName: isGridView ? "list.bullet" : "square.grid.2x2")
                    }

                    Button {
                        showingNewNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NoteDetailScreen(note: Note.empty)
            }
        }
    }
}

struct NotesGridView: View {
    let notes: [Note]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ForEach(notes) { note in
                    NavigationLink(destination: NoteDetailScreen(note: note)) {
                        NoteGridCard(note: note)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
        }
    }
}

struct NotesListView: View {
    let notes: [Note]

    var body: some View {
        List(notes) { note in
            NavigationLink(destination: NoteDetailScreen(note: note)) {
                NoteListRow(note: note)
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct NoteGridCard: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Text(note.title)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer()

                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundColor(note.color.color)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(note.color.color.opacity(0.2))

            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(note.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(6)
                    .multilineTextAlignment(.leading)

                Spacer()

                HStack {
                    Text(note.category.rawValue.capitalized)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(note.category.color.opacity(0.1))
                        .foregroundColor(note.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    Spacer()

                    Text(note.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(12)
        }
        .frame(height: 160)
        .background(note.color.color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct NoteListRow: View {
    let note: Note

    var body: some View {
        HStack(spacing: 16) {
            Rectangle()
                .fill(note.color.color)
                .frame(width: 4, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 2))

            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(note.title)
                        .font(.system(size: 16, weight: .bold))
                        .lineLimit(1)

                    Spacer()

                    if note.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Text(note.content)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                HStack {
                    Text(note.category.rawValue.capitalized)
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(note.category.color.opacity(0.1))
                        .foregroundColor(note.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()

                    Text(note.formattedDate)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct CategoryFilterChip: View {
    let category: NoteCategory?
    @Binding var selectedCategory: NoteCategory?
    let title: String

    var body: some View {
        Button {
            selectedCategory = category
        } label: {
            HStack(spacing: 6) {
                if let category = category {
                    Circle()
                        .fill(category.color)
                        .frame(width: 8, height: 8)
                }

                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(selectedCategory == category ? Color.blue.opacity(0.2) : Color(.systemGray6))
            .foregroundColor(selectedCategory == category ? .blue : .primary)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum NoteCategory: String, CaseIterable {
    case work = "work"
    case personal = "personal"
    case learning = "learning"
    case creative = "creative"
    case health = "health"

    var color: Color {
        switch self {
        case .work: return .blue
        case .personal: return .green
        case .learning: return .purple
        case .creative: return .pink
        case .health: return .red
        }
    }
}

enum NoteColor: CaseIterable {
    case blue, green, orange, purple, pink, red

    var color: Color {
        switch self {
        case .blue: return .blue
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .red: return .red
        }
    }
}

struct Note: Identifiable {
    let id: String
    let title: String
    let content: String
    let category: NoteCategory
    let color: NoteColor
    let lastModified: Date
    let isPinned: Bool

    var formattedDate: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.dateTimeStyle = .named
        return formatter.localizedString(for: lastModified, relativeTo: Date())
    }

    static let empty = Note(
        id: UUID().uuidString,
        title: "New Note",
        content: "",
        category: .personal,
        color: .blue,
        lastModified: Date(),
        isPinned: false
    )
}

#Preview {
    NotesListScreen()
}