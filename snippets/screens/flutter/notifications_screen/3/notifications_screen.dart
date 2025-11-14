import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NotificationItem> allNotifications = [
    NotificationItem(
      id: '1',
      type: NotificationType.like,
      username: 'alice_wonder',
      avatar: 'https://example.com/avatar3.jpg',
      content: 'liked your post',
      imageUrl: 'https://example.com/post1.jpg',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      type: NotificationType.follow,
      username: 'bob_builder',
      avatar: 'https://example.com/avatar4.jpg',
      content: 'started following you',
      timestamp: DateTime.now().subtract(Duration(minutes: 15)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      type: NotificationType.comment,
      username: 'charlie_brown',
      avatar: 'https://example.com/avatar5.jpg',
      content: 'commented on your post: "This is amazing! 🔥"',
      imageUrl: 'https://example.com/post2.jpg',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      type: NotificationType.mention,
      username: 'diana_prince',
      avatar: 'https://example.com/avatar6.jpg',
      content: 'mentioned you in a comment',
      imageUrl: 'https://example.com/post3.jpg',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      type: NotificationType.story,
      username: 'edward_stark',
      avatar: 'https://example.com/avatar7.jpg',
      content: 'viewed your story',
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      isRead: true,
    ),
    NotificationItem(
      id: '6',
      type: NotificationType.like,
      username: 'frank_castle',
      avatar: 'https://example.com/avatar8.jpg',
      content: 'and 12 others liked your post',
      imageUrl: 'https://example.com/post4.jpg',
      timestamp: DateTime.now().subtract(Duration(hours: 5)),
      isRead: true,
    ),
    NotificationItem(
      id: '7',
      type: NotificationType.follow_request,
      username: 'grace_hopper',
      avatar: 'https://example.com/avatar9.jpg',
      content: 'requested to follow you',
      timestamp: DateTime.now().subtract(Duration(days: 1)),
      isRead: false,
    ),
    NotificationItem(
      id: '8',
      type: NotificationType.live,
      username: 'henry_ford',
      avatar: 'https://example.com/avatar10.jpg',
      content: 'started a live video',
      timestamp: DateTime.now().subtract(Duration(days: 1, hours: 2)),
      isRead: true,
    ),
  ];

  List<NotificationItem> get todayNotifications =>
      allNotifications.where((n) =>
          n.timestamp.isAfter(DateTime.now().subtract(Duration(days: 1)))).toList();

  List<NotificationItem> get thisWeekNotifications =>
      allNotifications.where((n) =>
          n.timestamp.isBefore(DateTime.now().subtract(Duration(days: 1))) &&
          n.timestamp.isAfter(DateTime.now().subtract(Duration(days: 7)))).toList();

  List<NotificationItem> get followRequests =>
      allNotifications.where((n) => n.type == NotificationType.follow_request).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          if (_hasUnreadNotifications())
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Mark all read',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('All'),
                  if (_getUnreadCount() > 0)
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getUnreadCount().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Requests'),
                  if (followRequests.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        followRequests.length.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllNotifications(),
          _buildFollowRequests(),
        ],
      ),
    );
  }

  Widget _buildAllNotifications() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView(
        children: [
          if (todayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Today'),
            ...todayNotifications.map((notification) =>
                _buildNotificationItem(notification)),
          ],
          if (thisWeekNotifications.isNotEmpty) ...[
            _buildSectionHeader('This Week'),
            ...thisWeekNotifications.map((notification) =>
                _buildNotificationItem(notification)),
          ],
          if (allNotifications.isEmpty)
            _buildEmptyState('No notifications yet'),
        ],
      ),
    );
  }

  Widget _buildFollowRequests() {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: followRequests.isEmpty
          ? _buildEmptyState('No follow requests')
          : ListView.builder(
              itemCount: followRequests.length,
              itemBuilder: (context, index) {
                return _buildFollowRequestItem(followRequests[index]);
              },
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return ListTile(
      onTap: () => _handleNotificationTap(notification),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(notification.avatar),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _getNotificationColor(notification.type),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                _getNotificationIcon(notification.type),
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
        ],
      ),
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: notification.username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: ' ${notification.content}'),
          ],
        ),
      ),
      subtitle: Text(
        _formatTimestamp(notification.timestamp),
        style: TextStyle(color: Colors.grey),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (notification.imageUrl != null)
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(notification.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          if (!notification.isRead)
            Container(
              margin: EdgeInsets.only(left: 8),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFollowRequestItem(NotificationItem notification) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(notification.avatar),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        notification.content,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text(
                        _formatTimestamp(notification.timestamp),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _denyFollowRequest(notification),
                    child: Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptFollowRequest(notification),
                    child: Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Activity on your posts and profile will appear here',
              style: TextStyle(
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Icons.favorite;
      case NotificationType.comment:
        return Icons.comment;
      case NotificationType.follow:
      case NotificationType.follow_request:
        return Icons.person_add;
      case NotificationType.mention:
        return Icons.alternate_email;
      case NotificationType.story:
        return Icons.visibility;
      case NotificationType.live:
        return Icons.videocam;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.like:
        return Colors.red;
      case NotificationType.comment:
        return Colors.blue;
      case NotificationType.follow:
      case NotificationType.follow_request:
        return Colors.green;
      case NotificationType.mention:
        return Colors.orange;
      case NotificationType.story:
        return Colors.purple;
      case NotificationType.live:
        return Colors.pink;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  bool _hasUnreadNotifications() {
    return allNotifications.any((n) => !n.isRead);
  }

  int _getUnreadCount() {
    return allNotifications.where((n) => !n.isRead).length;
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('All notifications marked as read')),
    );
  }

  void _handleNotificationTap(NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    switch (notification.type) {
      case NotificationType.like:
      case NotificationType.comment:
      case NotificationType.mention:
        Navigator.pushNamed(context, '/post-detail',
            arguments: {'postId': 'sample_post'});
        break;
      case NotificationType.follow:
      case NotificationType.follow_request:
        Navigator.pushNamed(context, '/user-profile',
            arguments: notification.username);
        break;
      case NotificationType.story:
        Navigator.pushNamed(context, '/stories',
            arguments: notification.username);
        break;
      case NotificationType.live:
        Navigator.pushNamed(context, '/live-stream',
            arguments: notification.username);
        break;
    }
  }

  void _acceptFollowRequest(NotificationItem notification) {
    setState(() {
      allNotifications.remove(notification);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow request from ${notification.username} accepted'),
        action: SnackBarAction(
          label: 'View Profile',
          onPressed: () {
            Navigator.pushNamed(context, '/user-profile',
                arguments: notification.username);
          },
        ),
      ),
    );
  }

  void _denyFollowRequest(NotificationItem notification) {
    setState(() {
      allNotifications.remove(notification);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Follow request from ${notification.username} declined'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              allNotifications.add(notification);
            });
          },
        ),
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Add new notifications or update existing ones
      allNotifications.insert(0, NotificationItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: NotificationType.like,
        username: 'new_user',
        avatar: 'https://example.com/new_avatar.jpg',
        content: 'liked your recent post',
        timestamp: DateTime.now(),
        isRead: false,
      ));
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

enum NotificationType {
  like,
  comment,
  follow,
  follow_request,
  mention,
  story,
  live,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String username;
  final String avatar;
  final String content;
  final String? imageUrl;
  final DateTime timestamp;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.type,
    required this.username,
    required this.avatar,
    required this.content,
    this.imageUrl,
    required this.timestamp,
    required this.isRead,
  });
}