import 'package:flutter/material.dart';

abstract class NotificationStyler {
  Color backgroundColor(bool isRead);
  Widget buildIcon(IconData icon);
  TextStyle get titleTextStyle;
  TextStyle get bodyTextStyle;
  TextStyle get timestampTextStyle;
  EdgeInsets get itemPadding;
}

class CompactNotificationStyle implements NotificationStyler {
  @override
  Color backgroundColor(bool isRead) => isRead ? Colors.white : const Color(0xFFE3F2FD);

  @override
  Widget buildIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: const Color(0xFF1976D2), size: 20),
    );
  }

  @override
  TextStyle get titleTextStyle => const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 14,
      );

  @override
  TextStyle get bodyTextStyle => const TextStyle(
        fontSize: 13,
        color: Colors.black54,
      );

  @override
  TextStyle get timestampTextStyle => const TextStyle(
        fontSize: 11,
        color: Colors.grey,
      );

  @override
  EdgeInsets get itemPadding => const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      );
}

class NotificationsCenterScreen extends StatelessWidget {
  final NotificationStyler styler;
  final List<Notification> notifications;
  final Function(Notification)? onNotificationTap;

  const NotificationsCenterScreen({
    Key? key,
    NotificationStyler? styler,
    List<Notification>? notifications,
    this.onNotificationTap,
  })  : styler = styler ?? const CompactNotificationStyle(),
        notifications = notifications ?? const [],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = notifications.isEmpty ? _demoNotifications() : notifications;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) => _buildNotificationItem(items[index]),
      ),
    );
  }

  Widget _buildNotificationItem(Notification notification) {
    return InkWell(
      onTap: () => onNotificationTap?.call(notification),
      child: Container(
        color: styler.backgroundColor(notification.isRead),
        padding: styler.itemPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            styler.buildIcon(notification.iconData),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(notification.title, style: styler.titleTextStyle),
                  const SizedBox(height: 2),
                  Text(notification.message, style: styler.bodyTextStyle),
                  const SizedBox(height: 4),
                  Text(notification.timestamp, style: styler.timestampTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Notification> _demoNotifications() {
    return [
      Notification(
        id: '1',
        title: 'System Update',
        message: 'New features are now available',
        timestamp: '5m ago',
        isRead: false,
        iconData: Icons.system_update_alt,
      ),
      Notification(
        id: '2',
        title: 'New Comment',
        message: 'Someone commented on your post',
        timestamp: '1h ago',
        isRead: false,
        iconData: Icons.comment,
      ),
      Notification(
        id: '3',
        title: 'Security Alert',
        message: 'Login from new device detected',
        timestamp: '2h ago',
        isRead: true,
        iconData: Icons.security,
      ),
    ];
  }
}

class Notification {
  final String id;
  final String title;
  final String message;
  final String timestamp;
  final bool isRead;
  final IconData iconData;

  const Notification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.isRead,
    required this.iconData,
  });
}
