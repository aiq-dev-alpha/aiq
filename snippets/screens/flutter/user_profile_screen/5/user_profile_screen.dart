import 'package:flutter/material.dart';

abstract class ProfileStyler {
  Color get primaryColor;
  Color get backgroundColor;
  Widget buildAvatar(String? imageUrl, double size);
  Widget buildActionButton(String label, VoidCallback onTap);
  EdgeInsets get contentPadding;
}

class ModernProfileStyle implements ProfileStyler {
  @override
  Color get primaryColor => const Color(0xFF6200EE);

  @override
  Color get backgroundColor => const Color(0xFFFAFAFA);

  @override
  Widget buildAvatar(String? imageUrl, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
        ),
      ),
      child: const Icon(Icons.person, size: 48, color: Colors.white),
    );
  }

  @override
  Widget buildActionButton(String label, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label),
    );
  }

  @override
  EdgeInsets get contentPadding => const EdgeInsets.all(20);
}

class UserProfileScreen extends StatelessWidget {
  final ProfileStyler styler;
  final ProfileData data;
  final VoidCallback? onEditProfile;
  final VoidCallback? onShare;

  const UserProfileScreen({
    Key? key,
    ProfileStyler? styler,
    ProfileData? data,
    this.onEditProfile,
    this.onShare,
  })  : styler = styler ?? const ModernProfileStyle(),
        data = data ?? const ProfileData(name: 'User', username: '@user'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: styler.backgroundColor,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: styler.primaryColor,
        actions: [
          if (onShare != null)
            IconButton(icon: const Icon(Icons.share), onPressed: onShare),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: styler.primaryColor.withOpacity(0.1),
              padding: styler.contentPadding,
              child: Column(
                children: [
                  styler.buildAvatar(data.avatarUrl, 120),
                  const SizedBox(height: 16),
                  Text(
                    data.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.username,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  if (data.tagline != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      data.tagline!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStat('Posts', data.postsCount),
                      _buildStat('Followers', data.followersCount),
                      _buildStat('Following', data.followingCount),
                    ],
                  ),
                  if (onEditProfile != null) ...[
                    const SizedBox(height: 20),
                    styler.buildActionButton('Edit Profile', onEditProfile!),
                  ],
                ],
              ),
            ),
            Padding(
              padding: styler.contentPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Activity',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildActivityTile(Icons.favorite, 'Likes', data.likesCount),
                  _buildActivityTile(Icons.comment, 'Comments', data.commentsCount),
                  _buildActivityTile(Icons.bookmark, 'Saved', data.savedCount),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: styler.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActivityTile(IconData icon, String label, int count) {
    return ListTile(
      leading: Icon(icon, color: styler.primaryColor),
      title: Text(label),
      trailing: Text(count.toString(), style: const TextStyle(fontWeight: FontWeight.w600)),
      contentPadding: EdgeInsets.zero,
    );
  }
}

class ProfileData {
  final String name;
  final String username;
  final String? avatarUrl;
  final String? tagline;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final int commentsCount;
  final int savedCount;

  const ProfileData({
    required this.name,
    required this.username,
    this.avatarUrl,
    this.tagline,
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.savedCount = 0,
  });
}
