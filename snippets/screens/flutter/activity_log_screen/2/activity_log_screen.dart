import 'package:flutter/material.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({Key? key}) : super(key: key);

  @override
  State<ActivityLogScreen> createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  String selectedFilter = 'All';
  String selectedUser = 'All Users';
  DateTime? startDate;
  DateTime? endDate;

  final List<ActivityLogEntry> activities = [
    ActivityLogEntry(
      id: '1',
      user: 'John Smith',
      action: 'Completed purchase',
      details: 'Order #12345 - iPhone 14 Pro',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      type: ActivityType.purchase,
      severity: ActivitySeverity.info,
      metadata: {'amount': '\$999.99', 'orderId': '12345'},
    ),
    ActivityLogEntry(
      id: '2',
      user: 'Sarah Wilson',
      action: 'User registration',
      details: 'New account created with email verification',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      type: ActivityType.account,
      severity: ActivitySeverity.success,
      metadata: {'email': 'sarah.wilson@email.com'},
    ),
    ActivityLogEntry(
      id: '3',
      user: 'System',
      action: 'Failed payment attempt',
      details: 'Credit card declined for order #12344',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
      type: ActivityType.payment,
      severity: ActivitySeverity.error,
      metadata: {'orderId': '12344', 'reason': 'Insufficient funds'},
    ),
    ActivityLogEntry(
      id: '4',
      user: 'Mike Johnson',
      action: 'Profile updated',
      details: 'Changed shipping address and phone number',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      type: ActivityType.profile,
      severity: ActivitySeverity.info,
      metadata: {'fields': 'address, phone'},
    ),
    ActivityLogEntry(
      id: '5',
      user: 'Admin',
      action: 'Security alert',
      details: 'Multiple failed login attempts detected',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      type: ActivityType.security,
      severity: ActivitySeverity.warning,
      metadata: {'attempts': '5', 'ip': '192.168.1.100'},
    ),
    ActivityLogEntry(
      id: '6',
      user: 'Emma Davis',
      action: 'Product review',
      details: 'Left 5-star review for Wireless Headphones',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      type: ActivityType.review,
      severity: ActivitySeverity.success,
      metadata: {'rating': '5', 'productId': 'WH001'},
    ),
    ActivityLogEntry(
      id: '7',
      user: 'System',
      action: 'Data backup completed',
      details: 'Automated daily backup finished successfully',
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      type: ActivityType.system,
      severity: ActivitySeverity.success,
      metadata: {'size': '2.3GB', 'duration': '45min'},
    ),
    ActivityLogEntry(
      id: '8',
      user: 'Alex Rodriguez',
      action: 'Support ticket created',
      details: 'Issue with order delivery tracking',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      type: ActivityType.support,
      severity: ActivitySeverity.warning,
      metadata: {'ticketId': 'SUP-456', 'priority': 'Medium'},
    ),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Log'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'export', child: Text('Export Log')),
              const PopupMenuItem(value: 'clear', child: Text('Clear History')),
              const PopupMenuItem(value: 'settings', child: Text('Log Settings')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCards(),
          _buildActiveFilters(),
          Expanded(
            child: _buildActivityList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refreshActivities,
        child: const Icon(Icons.refresh),
        tooltip: 'Refresh Activities',
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Total Activities',
              activities.length.toString(),
              Icons.list_alt,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Critical',
              activities.where((a) => a.severity == ActivitySeverity.error).length.toString(),
              Icons.error,
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Recent (1h)',
              activities.where((a) => DateTime.now().difference(a.timestamp).inHours < 1).length.toString(),
              Icons.access_time,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters() {
    final hasActiveFilters = selectedFilter != 'All' ||
                           selectedUser != 'All Users' ||
                           startDate != null ||
                           endDate != null;

    if (!hasActiveFilters) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Filters:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              if (selectedFilter != 'All')
                _buildFilterChip('Type: $selectedFilter', () {
                  setState(() {
                    selectedFilter = 'All';
                  });
                }),
              if (selectedUser != 'All Users')
                _buildFilterChip('User: $selectedUser', () {
                  setState(() {
                    selectedUser = 'All Users';
                  });
                }),
              if (startDate != null)
                _buildFilterChip('From: ${_formatDate(startDate!)}', () {
                  setState(() {
                    startDate = null;
                  });
                }),
              if (endDate != null)
                _buildFilterChip('To: ${_formatDate(endDate!)}', () {
                  setState(() {
                    endDate = null;
                  });
                }),
              TextButton(
                onPressed: () {
                  setState(() {
                    selectedFilter = 'All';
                    selectedUser = 'All Users';
                    startDate = null;
                    endDate = null;
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Chip(
      label: Text(label),
      onDeleted: onRemove,
      deleteIcon: const Icon(Icons.close, size: 16),
      backgroundColor: Colors.blue.withOpacity(0.1),
      labelStyle: TextStyle(color: Colors.blue.shade700),
    );
  }

  Widget _buildActivityList() {
    final filteredActivities = _getFilteredActivities();

    if (filteredActivities.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredActivities.length,
      itemBuilder: (context, index) {
        final activity = filteredActivities[index];
        return _buildActivityCard(activity, index);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No activities found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your filters or check back later',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(ActivityLogEntry activity, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showActivityDetails(activity),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildActivityIcon(activity),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            activity.action,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        _buildSeverityBadge(activity.severity),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity.details,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          activity.user,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey.shade500,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTimestamp(activity.timestamp),
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    if (activity.metadata.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      _buildMetadataChips(activity.metadata),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActivityIcon(ActivityLogEntry activity) {
    IconData icon;
    Color color;

    switch (activity.type) {
      case ActivityType.purchase:
        icon = Icons.shopping_cart;
        color = Colors.green;
        break;
      case ActivityType.account:
        icon = Icons.account_circle;
        color = Colors.blue;
        break;
      case ActivityType.payment:
        icon = Icons.payment;
        color = Colors.orange;
        break;
      case ActivityType.profile:
        icon = Icons.edit;
        color = Colors.purple;
        break;
      case ActivityType.security:
        icon = Icons.security;
        color = Colors.red;
        break;
      case ActivityType.review:
        icon = Icons.star;
        color = Colors.amber;
        break;
      case ActivityType.system:
        icon = Icons.settings;
        color = Colors.grey;
        break;
      case ActivityType.support:
        icon = Icons.support_agent;
        color = Colors.cyan;
        break;
      default:
        icon = Icons.info;
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildSeverityBadge(ActivitySeverity severity) {
    Color color;
    String label;

    switch (severity) {
      case ActivitySeverity.info:
        color = Colors.blue;
        label = 'Info';
        break;
      case ActivitySeverity.success:
        color = Colors.green;
        label = 'Success';
        break;
      case ActivitySeverity.warning:
        color = Colors.orange;
        label = 'Warning';
        break;
      case ActivitySeverity.error:
        color = Colors.red;
        label = 'Error';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMetadataChips(Map<String, String> metadata) {
    return Wrap(
      spacing: 4,
      runSpacing: 2,
      children: metadata.entries.take(3).map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
            ),
          ),
        );
      }).toList(),
    );
  }

  List<ActivityLogEntry> _getFilteredActivities() {
    return activities.where((activity) {
      // Filter by type
      if (selectedFilter != 'All' && activity.type.toString().split('.').last != selectedFilter.toLowerCase()) {
        return false;
      }

      // Filter by user
      if (selectedUser != 'All Users' && activity.user != selectedUser) {
        return false;
      }

      // Filter by date range
      if (startDate != null && activity.timestamp.isBefore(startDate!)) {
        return false;
      }
      if (endDate != null && activity.timestamp.isAfter(endDate!.add(const Duration(days: 1)))) {
        return false;
      }

      return true;
    }).toList();
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Activities'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedFilter,
                decoration: const InputDecoration(
                  labelText: 'Activity Type',
                  border: OutlineInputBorder(),
                ),
                items: ['All', 'Purchase', 'Account', 'Payment', 'Profile', 'Security', 'Review', 'System', 'Support']
                    .map((filter) => DropdownMenuItem(
                          value: filter,
                          child: Text(filter),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedFilter = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedUser,
                decoration: const InputDecoration(
                  labelText: 'User',
                  border: OutlineInputBorder(),
                ),
                items: ['All Users', 'John Smith', 'Sarah Wilson', 'Mike Johnson', 'Emma Davis', 'Alex Rodriguez', 'Admin', 'System']
                    .map((user) => DropdownMenuItem(
                          value: user,
                          child: Text(user),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUser = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: startDate ?? DateTime.now(),
                          firstDate: DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            startDate = date;
                          });
                        }
                      },
                      child: Text(startDate != null ? 'From: ${_formatDate(startDate!)}' : 'Start Date'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: endDate ?? DateTime.now(),
                          firstDate: startDate ?? DateTime.now().subtract(const Duration(days: 365)),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            endDate = date;
                          });
                        }
                      },
                      child: Text(endDate != null ? 'To: ${_formatDate(endDate!)}' : 'End Date'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedFilter = 'All';
                selectedUser = 'All Users';
                startDate = null;
                endDate = null;
              });
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Activities'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Search by action, details, or user...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Implement search functionality
              },
            ),
            const SizedBox(height: 16),
            const Text('Quick Searches:'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Failed payments', 'New registrations', 'Security alerts', 'System errors']
                  .map((query) => ActionChip(
                        label: Text(query),
                        onPressed: () {
                          // Apply quick search
                        },
                      ))
                  .toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showActivityDetails(ActivityLogEntry activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(activity.action),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('User', activity.user),
              _buildDetailRow('Type', activity.type.toString().split('.').last),
              _buildDetailRow('Severity', activity.severity.toString().split('.').last),
              _buildDetailRow('Time', activity.timestamp.toString()),
              _buildDetailRow('Details', activity.details),
              if (activity.metadata.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text('Metadata:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...activity.metadata.entries.map((entry) =>
                  _buildDetailRow(entry.key, entry.value)),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Copy activity details
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity details copied to clipboard')),
              );
            },
            child: const Text('Copy'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _refreshActivities() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Activities refreshed')),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting activity log...')),
        );
        break;
      case 'clear':
        _showClearHistoryDialog();
        break;
      case 'settings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Opening log settings...')),
        );
        break;
    }
  }

  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Activity History'),
        content: const Text('Are you sure you want to clear all activity history? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Activity history cleared')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}

class ActivityLogEntry {
  final String id;
  final String user;
  final String action;
  final String details;
  final DateTime timestamp;
  final ActivityType type;
  final ActivitySeverity severity;
  final Map<String, String> metadata;

  ActivityLogEntry({
    required this.id,
    required this.user,
    required this.action,
    required this.details,
    required this.timestamp,
    required this.type,
    required this.severity,
    required this.metadata,
  });
}

enum ActivityType {
  purchase,
  account,
  payment,
  profile,
  security,
  review,
  system,
  support,
}

enum ActivitySeverity {
  info,
  success,
  warning,
  error,
}