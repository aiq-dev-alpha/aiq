import 'package:flutter/material.dart';

class FollowersScreen extends StatefulWidget {
  final String username;

  const FollowersScreen({Key? key, required this.username}) : super(key: key);

  @override
  _FollowersScreenState createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> followers = [
    User(
      id: '1',
      username: 'alice_wonder',
      displayName: 'Alice Wonder',
      avatar: 'https://example.com/avatar3.jpg',
      isFollowing: true,
      isFollowedBy: true,
    ),
    User(
      id: '2',
      username: 'bob_builder',
      displayName: 'Bob Builder',
      avatar: 'https://example.com/avatar4.jpg',
      isFollowing: false,
      isFollowedBy: true,
    ),
    User(
      id: '3',
      username: 'charlie_brown',
      displayName: 'Charlie Brown',
      avatar: 'https://example.com/avatar5.jpg',
      isFollowing: true,
      isFollowedBy: true,
    ),
    User(
      id: '4',
      username: 'diana_prince',
      displayName: 'Diana Prince',
      avatar: 'https://example.com/avatar6.jpg',
      isFollowing: false,
      isFollowedBy: true,
    ),
    User(
      id: '5',
      username: 'edward_stark',
      displayName: 'Edward Stark',
      avatar: 'https://example.com/avatar7.jpg',
      isFollowing: true,
      isFollowedBy: true,
    ),
  ];

  List<User> filteredFollowers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredFollowers = List.from(followers);
    _searchController.addListener(_filterFollowers);
  }

  void _filterFollowers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredFollowers = List.from(followers);
      } else {
        filteredFollowers = followers.where((user) {
          return user.username.toLowerCase().contains(query) ||
                 user.displayName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Followers'),
            Text(
              '${followers.length} followers',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search followers...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // Categories (optional)
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All', true),
                _buildCategoryChip('Following you back', false),
                _buildCategoryChip('Not following back', false),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Followers list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFollowers,
              child: ListView.builder(
                itemCount: filteredFollowers.length,
                itemBuilder: (context, index) {
                  return _buildFollowerItem(filteredFollowers[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // Implement filtering logic
          _filterByCategory(label);
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildFollowerItem(User user) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: GestureDetector(
        onTap: () => _navigateToProfile(user.username),
        child: CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(user.avatar),
        ),
      ),
      title: GestureDetector(
        onTap: () => _navigateToProfile(user.username),
        child: Text(
          user.username,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.displayName),
          if (user.isFollowedBy && user.isFollowing)
            Text(
              'Follows you',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
        ],
      ),
      trailing: _buildFollowButton(user),
    );
  }

  Widget _buildFollowButton(User user) {
    if (user.username == 'current_user') {
      return SizedBox.shrink(); // Don't show button for current user
    }

    return SizedBox(
      width: 100,
      height: 32,
      child: OutlinedButton(
        onPressed: () => _toggleFollow(user),
        style: OutlinedButton.styleFrom(
          backgroundColor: user.isFollowing ? Colors.grey[200] : Colors.transparent,
          side: BorderSide(
            color: user.isFollowing ? Colors.grey : Theme.of(context).primaryColor,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          user.isFollowing ? 'Following' : 'Follow',
          style: TextStyle(
            color: user.isFollowing ? Colors.black : Theme.of(context).primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _filterByCategory(String category) {
    setState(() {
      switch (category) {
        case 'All':
          filteredFollowers = List.from(followers);
          break;
        case 'Following you back':
          filteredFollowers = followers.where((user) => user.isFollowing).toList();
          break;
        case 'Not following back':
          filteredFollowers = followers.where((user) => !user.isFollowing).toList();
          break;
      }
    });
  }

  Future<void> _refreshFollowers() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // In real app, fetch updated followers list from server
    setState(() {
      isLoading = false;
    });
  }

  void _toggleFollow(User user) {
    setState(() {
      user.isFollowing = !user.isFollowing;
    });

    // Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          user.isFollowing
            ? 'You are now following ${user.username}'
            : 'You unfollowed ${user.username}',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _navigateToProfile(String username) {
    Navigator.pushNamed(
      context,
      '/user-profile',
      arguments: username,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class User {
  final String id;
  final String username;
  final String displayName;
  final String avatar;
  bool isFollowing;
  final bool isFollowedBy;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.isFollowing,
    required this.isFollowedBy,
  });
}