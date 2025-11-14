import SwiftUI

struct TasksListScreen: View {
    @State private var selectedTab = 0
    @State private var showingAddTask = false
    @State private var newTaskTitle = ""

    @State private var tasks = [
        Task(
            id: "1",
            title: "Complete project proposal",
            description: "Write and submit the Q4 project proposal for the mobile app redesign",
            isCompleted: false,
            priority: .high,
            dueDate: Calendar.current.date(byAdding: .day, value: 2, to: Date()),
            category: .work
        ),
        Task(
            id: "2",
            title: "Buy groceries",
            description: "Milk, bread, eggs, fruits, and vegetables for the week",
            isCompleted: false,
            priority: .medium,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            category: .personal
        ),
        Task(
            id: "3",
            title: "Review SwiftUI documentation",
            description: "Read through the latest SwiftUI documentation and new features",
            isCompleted: true,
            priority: .medium,
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()),
            category: .learning
        ),
        Task(
            id: "4",
            title: "Plan weekend trip",
            description: "Research destinations, book accommodation, and plan activities",
            isCompleted: false,
            priority: .low,
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date()),
            category: .personal
        ),
        Task(
            id: "5",
            title: "Call dentist appointment",
            description: "Schedule routine checkup and cleaning for next month",
            isCompleted: false,
            priority: .high,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            category: .health
        )
    ]

    var filteredTasks: [Task] {
        switch selectedTab {
        case 0: // All
            return tasks
        case 1: // Active
            return tasks.filter { !$0.isCompleted }
        case 2: // Completed
            return tasks.filter { $0.isCompleted }
        default:
            return tasks
        }
    }

    var activeTasksCount: Int {
        tasks.filter { !$0.isCompleted }.count
    }

    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }

    var progressPercentage: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedTasksCount) / Double(tasks.count)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Progress Summary
                ProgressSummaryView(
                    completed: completedTasksCount,
                    total: tasks.count,
                    percentage: progressPercentage
                )
                .padding(.horizontal)
                .padding(.bottom)

                // Tab Bar
                Picker("Filter", selection: $selectedTab) {
                    Text("All (\(tasks.count))").tag(0)
                    Text("Active (\(activeTasksCount))").tag(1)
                    Text("Done (\(completedTasksCount))").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 8)

                if filteredTasks.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Spacer()

                        Image(systemName: selectedTab == 2 ? "checkmark.circle" : "list.clipboard")
                            .font(.system(size: 64))
                            .foregroundColor(.gray.opacity(0.5))

                        Text(selectedTab == 2 ? "No completed tasks yet" : "No tasks yet")
                            .font(.title2)
                            .foregroundColor(.secondary)

                        if selectedTab != 2 {
                            Button("Add Task") {
                                showingAddTask = true
                            }
                            .buttonStyle(.bordered)
                        }

                        Spacer()
                    }
                } else {
                    // Tasks List
                    List {
                        ForEach(filteredTasks) { task in
                            NavigationLink(destination: TaskDetailScreen(task: task)) {
                                TaskRowView(task: task) {
                                    toggleTaskCompletion(task)
                                }
                            }
                        }
                        .onDelete(perform: deleteTasks)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Tasks")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        // Show sort options
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                    }

                    Button {
                        showingAddTask = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .alert("New Task", isPresented: $showingAddTask) {
                TextField("Task title", text: $newTaskTitle)
                Button("Cancel", role: .cancel) {
                    newTaskTitle = ""
                }
                Button("Add") {
                    addTask()
                }
            } message: {
                Text("Enter the task title")
            }
        }
    }

    private func toggleTaskCompletion(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    private func deleteTasks(at offsets: IndexSet) {
        for offset in offsets {
            let task = filteredTasks[offset]
            tasks.removeAll { $0.id == task.id }
        }
    }

    private func addTask() {
        let newTask = Task(
            id: UUID().uuidString,
            title: newTaskTitle,
            description: "",
            isCompleted: false,
            priority: .medium,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()),
            category: .personal
        )
        tasks.append(newTask)
        newTaskTitle = ""
    }
}

struct TaskRowView: View {
    let task: Task
    let onToggle: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Checkbox
            Button(action: onToggle) {
                ZStack {
                    Circle()
                        .stroke(task.isCompleted ? Color.green : task.priority.color, lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if task.isCompleted {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 24, height: 24)

                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())

            // Task Content
            VStack(alignment: .leading, spacing: 8) {
                // Title and Priority
                HStack {
                    Text(task.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(task.isCompleted ? .secondary : .primary)
                        .strikethrough(task.isCompleted)

                    Spacer()

                    // Priority Badge
                    Text(task.priority.rawValue.uppercased())
                        .font(.caption2)
                        .fontWeight(.bold)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(task.priority.color.opacity(0.1))
                        .foregroundColor(task.priority.color)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }

                // Description
                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .strikethrough(task.isCompleted)
                        .lineLimit(2)
                }

                // Meta info
                HStack {
                    // Category
                    Text(task.category.rawValue.capitalized)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(task.category.color.opacity(0.1))
                        .foregroundColor(task.category.color)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                    if let dueDate = task.dueDate {
                        HStack(spacing: 2) {
                            Image(systemName: "clock")
                                .font(.caption2)

                            Text(task.formattedDueDate)
                                .font(.caption2)
                        }
                        .foregroundColor(task.isOverdue ? .red : .secondary)
                        .fontWeight(task.isOverdue ? .semibold : .regular)
                    }

                    Spacer()
                }
            }

            // More actions
            Menu {
                Button("Edit") {
                    // Edit task
                }

                Button("Duplicate") {
                    // Duplicate task
                }

                Button("Delete", role: .destructive) {
                    // Delete task
                }
            } label: {
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct ProgressSummaryView: View {
    let completed: Int
    let total: Int
    let percentage: Double

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Today's Progress")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)

                Spacer()

                Text("\(Int(percentage * 100))%")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
            }

            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(completed) of \(total) tasks")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))

                    ProgressView(value: percentage)
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .scaleEffect(x: 1, y: 2, anchor: .center)
                }

                Spacer()
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [.blue, .blue.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

enum TaskPriority: String, CaseIterable {
    case high = "high"
    case medium = "medium"
    case low = "low"

    var color: Color {
        switch self {
        case .high: return .red
        case .medium: return .orange
        case .low: return .blue
        }
    }
}

enum TaskCategory: String, CaseIterable {
    case work = "work"
    case personal = "personal"
    case health = "health"
    case learning = "learning"
    case shopping = "shopping"

    var color: Color {
        switch self {
        case .work: return .blue
        case .personal: return .green
        case .health: return .red
        case .learning: return .purple
        case .shopping: return .orange
        }
    }
}

struct Task: Identifiable {
    let id: String
    let title: String
    let description: String
    var isCompleted: Bool
    let priority: TaskPriority
    let dueDate: Date?
    let category: TaskCategory

    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }

    var formattedDueDate: String {
        guard let dueDate = dueDate else { return "" }

        let calendar = Calendar.current
        let daysFromNow = calendar.dateComponents([.day], from: Date(), to: dueDate).day ?? 0

        if daysFromNow == 0 {
            return "Today"
        } else if daysFromNow == 1 {
            return "Tomorrow"
        } else if daysFromNow == -1 {
            return "Yesterday"
        } else if daysFromNow > 0 {
            return "In \(daysFromNow) days"
        } else {
            return "\(-daysFromNow) days ago"
        }
    }
}

#Preview {
    TasksListScreen()
}