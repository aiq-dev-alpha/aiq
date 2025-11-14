import 'package:flutter/material.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String selectedCategory = 'All';
  String selectedStatus = 'All';

  final List<Report> reports = [
    Report(
      id: '1',
      title: 'Monthly Revenue Report',
      description: 'Comprehensive revenue analysis for the current month',
      category: 'Financial',
      status: 'Completed',
      createdDate: DateTime.now().subtract(const Duration(days: 2)),
      completedDate: DateTime.now().subtract(const Duration(days: 1)),
      size: '2.5 MB',
      type: 'PDF',
    ),
    Report(
      id: '2',
      title: 'User Engagement Analytics',
      description: 'Detailed user behavior and engagement metrics',
      category: 'Analytics',
      status: 'Generating',
      createdDate: DateTime.now().subtract(const Duration(hours: 4)),
      completedDate: null,
      size: '1.8 MB',
      type: 'Excel',
    ),
    Report(
      id: '3',
      title: 'Performance Metrics Q1',
      description: 'First quarter performance overview and KPIs',
      category: 'Performance',
      status: 'Completed',
      createdDate: DateTime.now().subtract(const Duration(days: 7)),
      completedDate: DateTime.now().subtract(const Duration(days: 6)),
      size: '3.2 MB',
      type: 'PDF',
    ),
    Report(
      id: '4',
      title: 'Customer Segmentation Analysis',
      description: 'Customer demographic and behavioral segmentation',
      category: 'Marketing',
      status: 'Scheduled',
      createdDate: DateTime.now().subtract(const Duration(days: 1)),
      completedDate: null,
      size: 'TBD',
      type: 'Excel',
    ),
    Report(
      id: '5',
      title: 'Security Audit Report',
      description: 'Monthly security assessment and recommendations',
      category: 'Security',
      status: 'Failed',
      createdDate: DateTime.now().subtract(const Duration(days: 3)),
      completedDate: null,
      size: 'N/A',
      type: 'PDF',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showCreateReportDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSummaryCards(),
          _buildFiltersRow(),
          Expanded(
            child: _buildReportsList(),
          ),
        ],
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
              'Total Reports',
              reports.length.toString(),
              Icons.description,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Completed',
              reports.where((r) => r.status == 'Completed').length.toString(),
              Icons.check_circle,
              Colors.green,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Pending',
              reports.where((r) => r.status != 'Completed').length.toString(),
              Icons.pending,
              Colors.orange,
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildFiltersRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildFilterDropdown(
              'Category',
              selectedCategory,
              ['All', 'Financial', 'Analytics', 'Performance', 'Marketing', 'Security'],
              (value) => setState(() => selectedCategory = value!),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildFilterDropdown(
              'Status',
              selectedStatus,
              ['All', 'Completed', 'Generating', 'Scheduled', 'Failed'],
              (value) => setState(() => selectedStatus = value!),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> items,
    void Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: Text(label),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    final filteredReports = reports.where((report) {
      final categoryMatch = selectedCategory == 'All' || report.category == selectedCategory;
      final statusMatch = selectedStatus == 'All' || report.status == selectedStatus;
      return categoryMatch && statusMatch;
    }).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReports.length,
      itemBuilder: (context, index) {
        return _buildReportCard(filteredReports[index]);
      },
    );
  }

  Widget _buildReportCard(Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        onTap: () => _viewReport(report),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          report.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(report.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildInfoChip(report.category, Icons.category, Colors.blue),
                  const SizedBox(width: 8),
                  _buildInfoChip(report.type, Icons.file_present, Colors.green),
                  const SizedBox(width: 8),
                  _buildInfoChip(report.size, Icons.storage, Colors.purple),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Created: ${_formatDate(report.createdDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  if (report.completedDate != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.done, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(
                      'Completed: ${_formatDate(report.completedDate!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (report.status == 'Completed') ...[
                    ElevatedButton.icon(
                      onPressed: () => _downloadReport(report),
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Download'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (report.status == 'Failed') ...[
                    ElevatedButton.icon(
                      onPressed: () => _retryReport(report),
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  OutlinedButton.icon(
                    onPressed: () => _viewReportDetails(report),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 32),
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    onSelected: (action) => _handleReportAction(action, report),
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                      const PopupMenuItem(value: 'share', child: Text('Share')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete')),
                    ],
                    child: const Icon(Icons.more_vert),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    IconData icon;

    switch (status) {
      case 'Completed':
        color = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'Generating':
        color = Colors.blue;
        icon = Icons.hourglass_empty;
        break;
      case 'Scheduled':
        color = Colors.orange;
        icon = Icons.schedule;
        break;
      case 'Failed':
        color = Colors.red;
        icon = Icons.error;
        break;
      default:
        color = Colors.grey;
        icon = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Reports'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterDropdown(
              'Category',
              selectedCategory,
              ['All', 'Financial', 'Analytics', 'Performance', 'Marketing', 'Security'],
              (value) => setState(() => selectedCategory = value!),
            ),
            const SizedBox(height: 16),
            _buildFilterDropdown(
              'Status',
              selectedStatus,
              ['All', 'Completed', 'Generating', 'Scheduled', 'Failed'],
              (value) => setState(() => selectedStatus = value!),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedCategory = 'All';
                selectedStatus = 'All';
              });
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _showCreateReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Report Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              items: ['Financial', 'Analytics', 'Performance', 'Marketing', 'Security']
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report generation started')),
              );
            },
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  void _viewReport(Report report) {
    if (report.status == 'Completed') {
      Navigator.pushNamed(context, '/report-viewer', arguments: report);
    } else {
      _viewReportDetails(report);
    }
  }

  void _downloadReport(Report report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${report.title}...')),
    );
  }

  void _retryReport(Report report) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Retrying ${report.title}...')),
    );
  }

  void _viewReportDetails(Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${report.description}'),
            const SizedBox(height: 8),
            Text('Category: ${report.category}'),
            const SizedBox(height: 8),
            Text('Status: ${report.status}'),
            const SizedBox(height: 8),
            Text('Type: ${report.type}'),
            const SizedBox(height: 8),
            Text('Size: ${report.size}'),
            const SizedBox(height: 8),
            Text('Created: ${_formatDate(report.createdDate)}'),
            if (report.completedDate != null)
              Text('Completed: ${_formatDate(report.completedDate!)}'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleReportAction(String action, Report report) {
    switch (action) {
      case 'duplicate':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Duplicating ${report.title}...')),
        );
        break;
      case 'share':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sharing ${report.title}...')),
        );
        break;
      case 'delete':
        _confirmDeleteReport(report);
        break;
    }
  }

  void _confirmDeleteReport(Report report) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Report'),
        content: Text('Are you sure you want to delete "${report.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                reports.removeWhere((r) => r.id == report.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report deleted successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class Report {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final DateTime createdDate;
  final DateTime? completedDate;
  final String size;
  final String type;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdDate,
    required this.completedDate,
    required this.size,
    required this.type,
  });
}