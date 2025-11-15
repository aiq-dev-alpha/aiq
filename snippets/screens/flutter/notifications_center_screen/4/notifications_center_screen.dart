import 'package:flutter/material.dart';

class NotificationThemeConfig {
  final Color unreadColor;
  final Color readColor;
  final Color iconColor;
  final TextStyle titleStyle;
  final TextStyle bodyStyle;
  final TextStyle timeStyle;

  const NotificationThemeConfig({
    this.unreadColor = const Color(0xFFF0F8FF),
    this.readColor = Colors.white,
    this.iconColor = const Color(0xFF2196F3),
    this.titleStyle = const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    this.bodyStyle = const TextStyle(fontSize: 14, color: Colors.black87),
    this.timeStyle = const TextStyle(fontSize: 12, color: Colors.grey),
  });
}

class NotificationsCenterScreen extends StatefulWidget {
  final NotificationThemeConfig? themeConfig;
  final List<NotificationItem>? initialNotifications;

  const NotificationsCenterScreen({
    Key? key,
    this.themeConfig,
    this.initialNotifications,
  }) : super(key: key);

  @override
  State<NotificationsCenterScreen> createState() => _NotificationsCenterScreenState();
}

class _NotificationsCenterScreenState extends State<NotificationsCenterScreen> {
  late List<NotificationItem> _notifications;
  late NotificationThemeConfig _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.themeConfig ?? const NotificationThemeConfig();
    _notifications = widget.initialNotifications ?? _defaultNotifications();
  }

  List<NotificationItem> _defaultNotifications() {
    return [
      NotificationItem(
        id: '1',
        title: 'New message',
        body: 'You have a new message from John',
        time: '2 min ago',
        isRead: false,
        icon: Icons.message,
      ),
      NotificationItem(
        id: '2',
        title: 'Update available',
        body: 'A new version is available for download',
        time: '1 hour ago',
        isRead: false,
        icon: Icons.system_update,
      ),
      NotificationItem(
        id: '3',
        title: 'Payment received',
        body: 'Your payment of \$50 was successful',
        time: '3 hours ago',
        isRead: true,
        icon: Icons.payment,
      ),
    ];
  }

  void _markAsRead(String id) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == id);
      if (index != -1) {
        _notifications[index] = _notifications[index].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _notifications = _notifications
                    .map((n) => n.copyWith(isRead: true))
                    .toList();
              });
            },
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) => _NotificationTile(
          notification: _notifications[index],
          theme: _theme,
          onTap: () => _markAsRead(_notifications[index].id),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final NotificationThemeConfig theme;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.notification,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead ? theme.readColor : theme.unreadColor,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: theme.iconColor.withOpacity(0.1),
              child: Icon(notification.icon, color: theme.iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: theme.titleStyle),
                  const SizedBox(height: 4),
                  Text(notification.body, style: theme.bodyStyle),
                  const SizedBox(height: 4),
                  Text(notification.time, style: theme.timeStyle),
                ],
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.iconColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final IconData icon;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.icon,
  });

  NotificationItem copyWith({bool? isRead}) {
    return NotificationItem(
      id: id,
      title: title,
      body: body,
      time: time,
      isRead: isRead ?? this.isRead,
      icon: icon,
    );
  }
}
