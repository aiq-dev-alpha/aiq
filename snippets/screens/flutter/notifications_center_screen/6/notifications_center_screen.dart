import 'package:flutter/material.dart';

class NotificationConfig {
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final double itemSpacing;
  final bool groupByDate;
  final bool showAvatars;

  const NotificationConfig({
    this.primaryColor = const Color(0xFF6200EE),
    this.secondaryColor = const Color(0xFF018786),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.itemSpacing = 8.0,
    this.groupByDate = false,
    this.showAvatars = true,
  });
}

class NotificationsCenterScreen extends StatefulWidget {
  final NotificationConfig config;
  final Future<List<NotificationData>> Function()? fetchNotifications;

  const NotificationsCenterScreen({
    Key? key,
    this.config = const NotificationConfig(),
    this.fetchNotifications,
  }) : super(key: key);

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  List<NotificationData> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final fetcher = widget.fetchNotifications ?? _defaultFetch;
    final data = await fetcher();
    if (mounted) {
      setState(() {
        _items = data;
        _loading = false;
      });
    }
  }

  Future<List<NotificationData>> _defaultFetch() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return [
      NotificationData(
        id: '1',
        title: 'Welcome',
        body: 'Thanks for joining us',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: NotificationType.info,
      ),
      NotificationData(
        id: '2',
        title: 'New feature',
        body: 'Check out our latest update',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        type: NotificationType.announcement,
      ),
      NotificationData(
        id: '3',
        title: 'Action required',
        body: 'Please verify your email',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        type: NotificationType.warning,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: widget.config.primaryColor,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No notifications'))
              : ListView.separated(
                  padding: EdgeInsets.all(widget.config.itemSpacing),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => SizedBox(height: widget.config.itemSpacing),
                  itemBuilder: (context, index) => _NotificationCard(
                    data: _items[index],
                    config: widget.config,
                  ),
                ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationData data;
  final NotificationConfig config;

  const _NotificationCard({
    required this.data,
    required this.config,
  });

  IconData get _icon {
    switch (data.type) {
      case NotificationType.info:
        return Icons.info_outline;
      case NotificationType.warning:
        return Icons.warning_amber_outlined;
      case NotificationType.announcement:
        return Icons.campaign_outlined;
    }
  }

  Color get _iconColor {
    switch (data.type) {
      case NotificationType.info:
        return config.primaryColor;
      case NotificationType.warning:
        return Colors.orange;
      case NotificationType.announcement:
        return config.secondaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: config.showAvatars
            ? CircleAvatar(
                backgroundColor: _iconColor.withOpacity(0.1),
                child: Icon(_icon, color: _iconColor, size: 20),
              )
            : null,
        title: Text(data.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(data.body),
            const SizedBox(height: 4),
            Text(
              _formatTime(data.timestamp),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class NotificationData {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  final NotificationType type;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.type,
  });
}

enum NotificationType { info, warning, announcement }
