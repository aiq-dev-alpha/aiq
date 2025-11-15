import 'package:flutter/material.dart';

class ProfileTheme {
  final Color headerBackground;
  final Color contentBackground;
  final Color accentColor;
  final TextStyle nameStyle;
  final TextStyle bioStyle;
  final double avatarSize;

  const ProfileTheme({
    this.headerBackground = const Color(0xFF1976D2),
    this.contentBackground = Colors.white,
    this.accentColor = const Color(0xFF64B5F6),
    this.nameStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
    this.bioStyle = const TextStyle(fontSize: 14, color: Colors.white70),
    this.avatarSize = 100,
  });
}

class UserProfileScreen extends StatelessWidget {
  final ProfileTheme? theme;
  final UserProfile? profile;
  final VoidCallback? onEdit;

  const UserProfileScreen({
    Key? key,
    this.theme,
    this.profile,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const ProfileTheme();
    final userProfile = profile ?? _defaultProfile;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: effectiveTheme.headerBackground,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: effectiveTheme.headerBackground,
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: effectiveTheme.avatarSize / 2,
                        backgroundColor: effectiveTheme.accentColor,
                        child: const Icon(Icons.person, size: 48, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(userProfile.name, style: effectiveTheme.nameStyle),
                      const SizedBox(height: 4),
                      Text(userProfile.bio, style: effectiveTheme.bioStyle),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              if (onEdit != null)
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              color: effectiveTheme.contentBackground,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _StatRow(
                    stats: [
                      _Stat('Posts', userProfile.postsCount),
                      _Stat('Followers', userProfile.followersCount),
                      _Stat('Following', userProfile.followingCount),
                    ],
                    accentColor: effectiveTheme.accentColor,
                  ),
                  const SizedBox(height: 24),
                  _InfoSection(
                    title: 'About',
                    items: [
                      _InfoItem(Icons.email, userProfile.email),
                      _InfoItem(Icons.phone, userProfile.phone),
                      _InfoItem(Icons.location_on, userProfile.location),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final _defaultProfile = UserProfile(
    name: 'John Doe',
    bio: 'Software Developer',
    email: 'john@example.com',
    phone: '+1234567890',
    location: 'New York, USA',
    postsCount: 42,
    followersCount: 1234,
    followingCount: 567,
  );
}

class _StatRow extends StatelessWidget {
  final List<_Stat> stats;
  final Color accentColor;

  const _StatRow({required this.stats, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: stats.map((stat) => _StatItem(stat: stat, color: accentColor)).toList(),
    );
  }
}

class _StatItem extends StatelessWidget {
  final _Stat stat;
  final Color color;

  const _StatItem({required this.stat, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          stat.value.toString(),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 4),
        Text(stat.label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoItem> items;

  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

class _Stat {
  final String label;
  final int value;

  _Stat(this.label, this.value);
}

class UserProfile {
  final String name;
  final String bio;
  final String email;
  final String phone;
  final String location;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  UserProfile({
    required this.name,
    required this.bio,
    required this.email,
    required this.phone,
    required this.location,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });
}
