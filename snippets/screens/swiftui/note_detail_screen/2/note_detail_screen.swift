import SwiftUI

struct NoteDetailScreen: View {
    let note: Note
    @State private var title: String
    @State private var content: String
    @State private var selectedCategory: NoteCategory
    @State private var selectedColor: NoteColor
    @State private var isPinned: Bool
    @State private var hasUnsavedChanges = false
    @State private var showingColorPicker = false
    @Environment(\.dismiss) private var dismiss

    init(note: Note) {
        self.note = note
        self._title = State(initialValue: note.title)
        self._content = State(initialValue: note.content)
        self._selectedCategory = State(initialValue: note.category)
        self._selectedColor = State(initialValue: note.color)
        self._isPinned = State(initialValue: note.isPinned)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Color indicator bar
                Rectangle()
                    .fill(selectedColor.color)
                    .frame(height: 4)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Title
                        TextField("Note title...", text: $title, axis: .vertical)
                            .font(.title2)
                            .fontWeight(.bold)
                            .lineLimit(2)
                            .onChange(of: title) { _, _ in
                                hasUnsavedChanges = true
                            }

                        // Meta info
                        HStack {
                            // Category picker
                            Menu {
                                ForEach(NoteCategory.allCases, id: \.self) { category in
                                    Button {
                                        selectedCategory = category
                                        hasUnsavedChanges = true
                                    } label: {
                                        HStack {
                                            Circle()
                                                .fill(category.color)
                                                .frame(width: 12, height: 12)
                                            Text(category.rawValue.capitalized)
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(selectedCategory.color)
                                        .frame(width: 12, height: 12)
                                    Text(selectedCategory.rawValue.capitalized)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(selectedCategory.color.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            // Color picker
                            Button {
                                showingColorPicker = true
                            } label: {
                                Circle()
                                    .fill(selectedColor.color)
                                    .frame(width: 24, height: 24)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 1)
                                    )
                            }

                            Spacer()

                            // Word count
                            Text("\(content.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }.count) words")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        // Content
                        TextField("Start writing...", text: $content, axis: .vertical)
                            .font(.body)
                            .lineLimit(5...)
                            .onChange(of: content) { _, _ in
                                hasUnsavedChanges = true
                            }

                        Spacer()
                    }
                    .padding()
                }
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        if hasUnsavedChanges {
                            saveNote()
                        }
                        dismiss()
                    }
                }

                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        isPinned.toggle()
                        hasUnsavedChanges = true
                    } label: {
                        Image(systemName: isPinned ? "pin.fill" : "pin")
                    }

                    Menu {
                        Button("Share") {
                            // Share note
                        }

                        Button("Export") {
                            // Export note
                        }

                        Button("Delete", role: .destructive) {
                            // Delete note
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showingColorPicker) {
            ColorPickerSheet(selectedColor: $selectedColor) {
                hasUnsavedChanges = true
            }
        }
    }

    private func saveNote() {
        // Save note logic
        hasUnsavedChanges = false
    }
}

struct ColorPickerSheet: View {
    @Binding var selectedColor: NoteColor
    let onChange: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Select Color")
                    .font(.headline)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 6), spacing: 16) {
                    ForEach(NoteColor.allCases, id: \.self) { color in
                        Button {
                            selectedColor = color
                            onChange()
                            dismiss()
                        } label: {
                            Circle()
                                .fill(color.color)
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Circle()
                                        .stroke(selectedColor == color ? Color.primary : Color.clear, lineWidth: 3)
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    NoteDetailScreen(
        note: Note(
            id: "1",
            title: "Sample Note",
            content: "This is sample content",
            category: .work,
            color: .blue,
            lastModified: Date(),
            isPinned: false
        )
    )
}