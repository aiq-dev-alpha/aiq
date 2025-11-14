import 'package:flutter/material.dart';

class TasksListScreen extends StatefulWidget {
  const TasksListScreen({super.key});

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _taskController = TextEditingController();

  final List<Task> _tasks = [
    Task(
      id: '1',
      title: 'Complete project proposal',
      description: 'Write and submit the Q4 project proposal for the mobile app redesign',
      isCompleted: false,
      priority: TaskPriority.high,
      dueDate: DateTime.now().add(const Duration(days: 2)),
      category: TaskCategory.work,
    ),
    Task(
      id: '2',
      title: 'Buy groceries',
      description: 'Milk, bread, eggs, fruits, and vegetables for the week',
      isCompleted: false,
      priority: TaskPriority.medium,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      category: TaskCategory.personal,
    ),
    Task(
      id: '3',
      title: 'Review Flutter documentation',
      description: 'Read through the latest Flutter 3.x documentation and new features',
      isCompleted: true,
      priority: TaskPriority.medium,
      dueDate: DateTime.now().subtract(const Duration(days: 1)),
      category: TaskCategory.learning,
    ),
    Task(
      id: '4',
      title: 'Plan weekend trip',
      description: 'Research destinations, book accommodation, and plan activities',
      isCompleted: false,
      priority: TaskPriority.low,
      dueDate: DateTime.now().add(const Duration(days: 7)),
      category: TaskCategory.personal,
    ),
    Task(
      id: '5',
      title: 'Call dentist appointment',
      description: 'Schedule routine checkup and cleaning for next month',
      isCompleted: false,
      priority: TaskPriority.high,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      category: TaskCategory.health,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Task> get _filteredTasks {
    switch (_tabController.index) {
      case 0: // All
        return _tasks;
      case 1: // Active
        return _tasks.where((task) => !task.isCompleted).toList();
      case 2: // Completed
        return _tasks.where((task) => task.isCompleted).toList();
      default:
        return _tasks;
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeTasks = _tasks.where((task) => !task.isCompleted).length;
    final completedTasks = _tasks.where((task) => task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortDialog(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {}),
          tabs: [
            Tab(text: 'All (${_tasks.length})'),
            Tab(text: 'Active ($activeTasks)'),
            Tab(text: 'Done ($completedTasks)'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Summary
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade400, Colors.blue.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$completedTasks of ${_tasks.length} tasks',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: _tasks.isEmpty ? 0 : completedTasks / _tasks.length,
                            backgroundColor: Colors.white30,
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Text(
                        '${(_tasks.isEmpty ? 0 : (completedTasks / _tasks.length * 100)).round()}%',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTasksList(),
                _buildTasksList(),
                _buildTasksList(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksList() {
    final tasks = _filteredTasks;

    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _tabController.index == 2 ? Icons.task_alt : Icons.assignment,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _tabController.index == 2
                  ? 'No completed tasks yet'
                  : 'No tasks yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (_tabController.index != 2) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _showAddTaskDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isOverdue = !task.isCompleted &&
                         task.dueDate != null &&
                         task.dueDate!.isBefore(DateTime.now());

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: InkWell(
            onTap: () => _navigateToTaskDetail(task),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Checkbox
                      InkWell(
                        onTap: () => _toggleTaskCompletion(task),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: task.isCompleted
                                  ? Colors.green
                                  : _getPriorityColor(task.priority),
                              width: 2,
                            ),
                            color: task.isCompleted ? Colors.green : Colors.transparent,
                          ),
                          child: task.isCompleted
                              ? const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Task Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    task.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      decoration: task.isCompleted
                                          ? TextDecoration.lineThrough
                                          : null,
                                      color: task.isCompleted
                                          ? Colors.grey
                                          : null,
                                    ),
                                  ),
                                ),
                                // Priority Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getPriorityColor(task.priority).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    _getPriorityName(task.priority),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getPriorityColor(task.priority),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            if (task.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                task.description,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],

                            const SizedBox(height: 8),

                            // Task Meta
                            Row(
                              children: [
                                // Category
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getCategoryColor(task.category).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _getCategoryName(task.category),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: _getCategoryColor(task.category),
                                    ),
                                  ),
                                ),

                                if (task.dueDate != null) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.schedule,
                                    size: 14,
                                    color: isOverdue ? Colors.red : Colors.grey[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatDueDate(task.dueDate!),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isOverdue ? Colors.red : Colors.grey[600],
                                      fontWeight: isOverdue ? FontWeight.w600 : null,
                                    ),
                                  ),
                                ],

                                const Spacer(),

                                // More Options
                                PopupMenuButton<String>(
                                  onSelected: (value) => _handleTaskAction(value, task),
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: ListTile(
                                        leading: Icon(Icons.edit, size: 20),
                                        title: Text('Edit'),
                                        dense: true,
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'duplicate',
                                      child: ListTile(
                                        leading: Icon(Icons.copy, size: 20),
                                        title: Text('Duplicate'),
                                        dense: true,
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: ListTile(
                                        leading: Icon(Icons.delete, size: 20, color: Colors.red),
                                        title: Text('Delete', style: TextStyle(color: Colors.red)),
                                        dense: true,
                                      ),
                                    ),
                                  ],
                                  child: Icon(
                                    Icons.more_vert,
                                    color: Colors.grey[600],
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.blue;
    }
  }

  String _getPriorityName(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return 'HIGH';
      case TaskPriority.medium:
        return 'MED';
      case TaskPriority.low:
        return 'LOW';
    }
  }

  Color _getCategoryColor(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return Colors.blue;
      case TaskCategory.personal:
        return Colors.green;
      case TaskCategory.health:
        return Colors.red;
      case TaskCategory.learning:
        return Colors.purple;
      case TaskCategory.shopping:
        return Colors.orange;
    }
  }

  String _getCategoryName(TaskCategory category) {
    switch (category) {
      case TaskCategory.work:
        return 'Work';
      case TaskCategory.personal:
        return 'Personal';
      case TaskCategory.health:
        return 'Health';
      case TaskCategory.learning:
        return 'Learning';
      case TaskCategory.shopping:
        return 'Shopping';
    }
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference == -1) {
      return 'Yesterday';
    } else if (difference > 0) {
      return 'In $difference days';
    } else {
      return '${-difference} days ago';
    }
  }

  void _toggleTaskCompletion(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          task.isCompleted
              ? 'Task completed!'
              : 'Task marked as active',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _navigateToTaskDetail(Task task) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(task: task),
      ),
    );
  }

  void _handleTaskAction(String action, Task task) {
    switch (action) {
      case 'edit':
        _editTask(task);
        break;
      case 'duplicate':
        _duplicateTask(task);
        break;
      case 'delete':
        _deleteTask(task);
        break;
    }
  }

  void _editTask(Task task) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit task functionality would be implemented here')),
    );
  }

  void _duplicateTask(Task task) {
    setState(() {
      _tasks.add(Task(
        id: '${_tasks.length + 1}',
        title: '${task.title} (Copy)',
        description: task.description,
        isCompleted: false,
        priority: task.priority,
        dueDate: task.dueDate,
        category: task.category,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task duplicated!')),
    );
  }

  void _deleteTask(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _tasks.removeWhere((t) => t.id == task.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(
            hintText: 'Enter task title...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _taskController.clear();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_taskController.text.trim().isNotEmpty) {
                setState(() {
                  _tasks.add(Task(
                    id: '${_tasks.length + 1}',
                    title: _taskController.text.trim(),
                    description: '',
                    isCompleted: false,
                    priority: TaskPriority.medium,
                    dueDate: DateTime.now().add(const Duration(days: 1)),
                    category: TaskCategory.personal,
                  ));
                });
                _taskController.clear();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Task added!')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sort options would be implemented here')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskController.dispose();
    super.dispose();
  }
}

enum TaskPriority { high, medium, low }
enum TaskCategory { work, personal, health, learning, shopping }

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;
  final TaskPriority priority;
  final DateTime? dueDate;
  final TaskCategory category;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.priority,
    this.dueDate,
    required this.category,
  });
}

// This would typically be in a separate file
class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
      ),
      body: const Center(
        child: Text('Task Detail Screen'),
      ),
    );
  }
}