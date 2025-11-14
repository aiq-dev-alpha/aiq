import SwiftUI

struct TaskDetailScreen: View {
    let task: Task
    @State private var isEditing = false
    @State private var editedTitle: String
    @State private var editedDescription: String
    @State private var isCompleted: Bool
    @State private var selectedPriority: TaskPriority
    @State private var selectedCategory: TaskCategory
    @State private var selectedDate: Date

    init(task: Task) {
        self.task = task
        self._editedTitle = State(initialValue: task.title)
        self._editedDescription = State(initialValue: task.description)
        self._isCompleted = State(initialValue: task.isCompleted)
        self._selectedPriority = State(initialValue: task.priority)
        self._selectedCategory = State(initialValue: task.category)
        self._selectedDate = State(initialValue: task.dueDate ?? Date())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Task Status
                TaskStatusCard(isCompleted: $isCompleted)

                // Task Title
                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Task Title")
                            .font(.headline)
                            .fontWeight(.bold)

                        TextField("Enter task title", text: $editedTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                } else {
                    TaskInfoSection(
                        icon: "text.alignleft",
                        iconColor: .blue,
                        title: "Task Title",
                        content: task.title
                    )
                }

                // Description
                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                            .fontWeight(.bold)

                        TextField("Enter description", text: $editedDescription, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .lineLimit(3...6)
                    }
                } else {
                    TaskInfoSection(
                        icon: "doc.text",
                        iconColor: .orange,
                        title: "Description",
                        content: task.description.isEmpty ? "No description" : task.description
                    )
                }

                // Task Properties
                HStack(spacing: 12) {
                    if isEditing {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Priority")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Menu {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    Button(priority.rawValue.capitalized) {
                                        selectedPriority = priority
                                    }
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(selectedPriority.color)
                                        .frame(width: 12, height: 12)
                                    Text(selectedPriority.rawValue.capitalized)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    } else {
                        TaskPropertyCard(
                            icon: "flag.fill",
                            iconColor: task.priority.color,
                            title: "Priority",
                            value: task.priority.rawValue.capitalized
                        )
                    }

                    if isEditing {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Category")
                                .font(.subheadline)
                                .fontWeight(.semibold)

                            Menu {
                                ForEach(TaskCategory.allCases, id: \.self) { category in
                                    Button(category.rawValue.capitalized) {
                                        selectedCategory = category
                                    }
                                }
                            } label: {
                                HStack {
                                    Circle()
                                        .fill(selectedCategory.color)
                                        .frame(width: 12, height: 12)
                                    Text(selectedCategory.rawValue.capitalized)
                                    Spacer()
                                    Image(systemName: "chevron.down")
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    } else {
                        TaskPropertyCard(
                            icon: "folder.fill",
                            iconColor: task.category.color,
                            title: "Category",
                            value: task.category.rawValue.capitalized
                        )
                    }
                }

                // Due Date
                if isEditing {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Due Date")
                            .font(.headline)
                            .fontWeight(.bold)

                        DatePicker("Select date", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                } else {
                    TaskInfoSection(
                        icon: "calendar",
                        iconColor: .green,
                        title: "Due Date",
                        content: task.dueDate?.formatted(date: .abbreviated, time: .shortened) ?? "No due date"
                    )
                }

                // Notes
                TaskInfoSection(
                    icon: "note.text",
                    iconColor: .purple,
                    title: "Notes",
                    content: "Additional notes and context for this task..."
                )

                // Actions (only when not editing)
                if !isEditing {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Actions")
                            .font(.headline)
                            .fontWeight(.bold)

                        HStack(spacing: 12) {
                            Button("Set Reminder") {
                                // Set reminder
                            }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity)

                            Button("Add Subtask") {
                                // Add subtask
                            }
                            .buttonStyle(.bordered)
                            .frame(maxWidth: .infinity)
                        }

                        SubtasksSection()
                    }
                }
            }
            .padding()
        }
        .navigationTitle(isEditing ? "Edit Task" : task.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                if isEditing {
                    Button("Cancel") {
                        isEditing = false
                    }

                    Button("Save") {
                        saveTask()
                    }
                    .fontWeight(.semibold)
                } else {
                    Button {
                        isEditing = true
                    } label: {
                        Image(systemName: "pencil")
                    }

                    Menu {
                        Button("Duplicate") {
                            // Duplicate task
                        }

                        Button("Share") {
                            // Share task
                        }

                        Button("Delete", role: .destructive) {
                            // Delete task
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }

    private func saveTask() {
        // Save task changes
        isEditing = false
    }
}

struct TaskStatusCard: View {
    @Binding var isCompleted: Bool

    var body: some View {
        HStack(spacing: 16) {
            Button {
                isCompleted.toggle()
            } label: {
                ZStack {
                    Circle()
                        .stroke(isCompleted ? Color.green : Color.blue, lineWidth: 3)
                        .frame(width: 50, height: 50)

                    if isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 50, height: 50)

                        Image(systemName: "checkmark")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            VStack(alignment: .leading, spacing: 4) {
                Text(isCompleted ? "Task Completed" : "Task Active")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(isCompleted ? .green : .primary)

                Text(isCompleted ? "Great job! This task has been completed." : "Tap the circle to mark as complete.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct TaskInfoSection: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)

            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(iconColor)
                    .frame(width: 24)

                Text(content)
                    .font(.body)
                    .foregroundColor(content.contains("No ") ? .secondary : .primary)

                Spacer()
            }
            .padding()
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct TaskPropertyCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SubtasksSection: View {
    let subtasks = [
        ("Research project requirements", true),
        ("Create project outline", true),
        ("Write introduction section", false),
        ("Review and edit content", false),
        ("Submit final proposal", false)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Subtasks (2/5 completed)")
                .font(.headline)
                .fontWeight(.bold)

            VStack(spacing: 1) {
                ForEach(subtasks.indices, id: \.self) { index in
                    SubtaskRow(
                        title: subtasks[index].0,
                        isCompleted: subtasks[index].1
                    )

                    if index < subtasks.count - 1 {
                        Divider()
                            .padding(.leading, 40)
                    }
                }
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct SubtaskRow: View {
    let title: String
    let isCompleted: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isCompleted ? .green : .secondary)

            Text(title)
                .font(.body)
                .strikethrough(isCompleted)
                .foregroundColor(isCompleted ? .secondary : .primary)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    NavigationStack {
        TaskDetailScreen(
            task: Task(
                id: "1",
                title: "Complete project proposal",
                description: "Write and submit the Q4 project proposal",
                isCompleted: false,
                priority: .high,
                dueDate: Date(),
                category: .work
            )
        )
    }
}