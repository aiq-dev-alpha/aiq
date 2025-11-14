import 'package:flutter/material.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;

  late bool _isCompleted;
  late TaskPriority _priority;
  late TaskCategory _category;
  late DateTime? _dueDate;
  late TimeOfDay? _dueTime;

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description);
    _notesController = TextEditingController(text: 'Additional notes and context for this task...');

    _isCompleted = widget.task.isCompleted;
    _priority = widget.task.priority;
    _category = widget.task.category;
    _dueDate = widget.task.dueDate;
    _dueTime = widget.task.dueDate != null
        ? TimeOfDay.fromDateTime(widget.task.dueDate!)
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Task' : 'Task Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_isEditing) ...[
            TextButton(
              onPressed: () => _cancelEdit(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => _saveTask(),
              child: const Text('Save'),
            ),
          ] else ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => setState(() => _isEditing = true),
            ),
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'duplicate',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Duplicate Task'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share Task'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete Task', style: TextStyle(color: Colors.red)),
                    dense: true,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => setState(() => _isCompleted = !_isCompleted),
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isCompleted
                                ? Colors.green
                                : _getPriorityColor(_priority),
                            width: 3,
                          ),
                          color: _isCompleted ? Colors.green : Colors.transparent,
                        ),
                        child: _isCompleted
                            ? const Icon(
                                Icons.check,
                                size: 30,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _isCompleted ? 'Task Completed' : 'Task Active',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _isCompleted ? Colors.green : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _isCompleted
                                ? 'Great job! This task has been completed.'
                                : 'Tap the circle to mark as complete.',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Task Title
            Text(
              'Task Title',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isEditing
                ? TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter task title',
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.title, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _titleController.text,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            // Task Description
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isEditing
                ? TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter task description',
                    ),
                    maxLines: 3,
                  )
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.description, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _descriptionController.text.isNotEmpty
                                  ? _descriptionController.text
                                  : 'No description provided',
                              style: TextStyle(
                                color: _descriptionController.text.isEmpty
                                    ? Colors.grey[600]
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            // Task Properties
            Row(
              children: [
                Expanded(
                  child: _buildPropertyCard(
                    title: 'Priority',
                    icon: Icons.flag,
                    iconColor: _getPriorityColor(_priority),
                    value: _getPriorityName(_priority),
                    isEditing: _isEditing,
                    onTap: _isEditing ? () => _showPriorityPicker() : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPropertyCard(
                    title: 'Category',
                    icon: Icons.category,
                    iconColor: _getCategoryColor(_category),
                    value: _getCategoryName(_category),
                    isEditing: _isEditing,
                    onTap: _isEditing ? () => _showCategoryPicker() : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Due Date
            _buildPropertyCard(
              title: 'Due Date',
              icon: Icons.calendar_today,
              iconColor: Colors.green,
              value: _dueDate != null
                  ? '${_formatDate(_dueDate!)} at ${_dueTime?.format(context) ?? '12:00 PM'}'
                  : 'No due date set',
              isEditing: _isEditing,
              onTap: _isEditing ? () => _showDateTimePicker() : null,
              fullWidth: true,
            ),

            const SizedBox(height: 20),

            // Task Notes
            Text(
              'Notes',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _isEditing
                ? TextField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Add notes or additional context',
                    ),
                    maxLines: 4,
                  )
                : Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.note, color: Colors.purple),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _notesController.text,
                              style: const TextStyle(height: 1.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

            const SizedBox(height: 20),

            // Task Actions (only in view mode)
            if (!_isEditing) ...[
              Text(
                'Actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _setReminder(),
                      icon: const Icon(Icons.alarm),
                      label: const Text('Set Reminder'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _addSubtask(),
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subtask'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Subtasks Preview
              _buildSubtasksSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required String value,
    required bool isEditing,
    VoidCallback? onTap,
    bool fullWidth = false,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: fullWidth
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
                children: [
                  Icon(icon, color: iconColor, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  if (isEditing && onTap != null)
                    const Icon(Icons.chevron_right, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: fullWidth ? TextAlign.start : TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtasksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Subtasks (2/5 completed)',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: [
              _buildSubtaskItem('Research project requirements', true),
              const Divider(height: 1),
              _buildSubtaskItem('Create project outline', true),
              const Divider(height: 1),
              _buildSubtaskItem('Write introduction section', false),
              const Divider(height: 1),
              _buildSubtaskItem('Review and edit content', false),
              const Divider(height: 1),
              _buildSubtaskItem('Submit final proposal', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubtaskItem(String title, bool isCompleted) {
    return ListTile(
      leading: Icon(
        isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
        color: isCompleted ? Colors.green : Colors.grey,
      ),
      title: Text(
        title,
        style: TextStyle(
          decoration: isCompleted ? TextDecoration.lineThrough : null,
          color: isCompleted ? Colors.grey : null,
        ),
      ),
      onTap: () {
        // Toggle subtask completion
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCompleted
                  ? 'Subtask marked as incomplete'
                  : 'Subtask completed!',
            ),
          ),
        );
      },
    );
  }

  void _showPriorityPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Priority'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskPriority.values.map((priority) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getPriorityColor(priority),
                radius: 8,
              ),
              title: Text(_getPriorityName(priority)),
              selected: _priority == priority,
              onTap: () {
                setState(() {
                  _priority = priority;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showCategoryPicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: TaskCategory.values.map((category) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: _getCategoryColor(category),
                radius: 8,
              ),
              title: Text(_getCategoryName(category)),
              selected: _category == category,
              onTap: () {
                setState(() {
                  _category = category;
                });
                Navigator.of(context).pop();
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showDateTimePicker() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: _dueTime ?? TimeOfDay.now(),
      );

      if (selectedTime != null) {
        setState(() {
          _dueDate = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
          _dueTime = selectedTime;
        });
      }
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
      // Reset values to original
      _titleController.text = widget.task.title;
      _descriptionController.text = widget.task.description;
      _isCompleted = widget.task.isCompleted;
      _priority = widget.task.priority;
      _category = widget.task.category;
      _dueDate = widget.task.dueDate;
      _dueTime = widget.task.dueDate != null
          ? TimeOfDay.fromDateTime(widget.task.dueDate!)
          : null;
    });
  }

  void _saveTask() {
    // In a real app, this would save to a database or state management
    setState(() {
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _duplicateTask();
        break;
      case 'share':
        _shareTask();
        break;
      case 'delete':
        _deleteTask();
        break;
    }
  }

  void _duplicateTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task duplicated!')),
    );
  }

  void _shareTask() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing task...')),
    );
  }

  void _deleteTask() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
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

  void _setReminder() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reminder set!')),
    );
  }

  void _addSubtask() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add subtask functionality would be implemented here')),
    );
  }

  // Helper methods
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
        return 'High Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.low:
        return 'Low Priority';
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

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// These enums and classes would typically be in shared files
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