import 'package:flutter/material.dart';

class FollowingScreen extends StatefulWidget {
  final String username;

  const FollowingScreen({Key? key, required this.username}) : super(key: key);

  @override
  _FollowingScreenState createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> following = [
    User(
      id: '1',
      username: 'alice_wonder',
      displayName: 'Alice Wonder',
      avatar: 'https://example.com/avatar3.jpg',
      isFollowing: true,
      isFollowedBy: true,
      followedDate: '2 months ago',
    ),
    User(
      id: '2',
      username: 'bob_builder',
      displayName: 'Bob Builder',
      avatar: 'https://example.com/avatar4.jpg',
      isFollowing: true,
      isFollowedBy: false,
      followedDate: '1 month ago',
    ),
    User(
      id: '3',
      username: 'charlie_brown',
      displayName: 'Charlie Brown',
      avatar: 'https://example.com/avatar5.jpg',
      isFollowing: true,
      isFollowedBy: true,
      followedDate: '3 weeks ago',
    ),
    User(
      id: '4',
      username: 'diana_prince',
      displayName: 'Diana Prince',
      avatar: 'https://example.com/avatar6.jpg',
      isFollowing: true,
      isFollowedBy: false,
      followedDate: '2 weeks ago',
    ),
    User(
      id: '5',
      username: 'edward_stark',
      displayName: 'Edward Stark',
      avatar: 'https://example.com/avatar7.jpg',
      isFollowing: true,
      isFollowedBy: true,
      followedDate: '1 week ago',
    ),
    User(
      id: '6',
      username: 'frank_castle',
      displayName: 'Frank Castle',
      avatar: 'https://example.com/avatar8.jpg',
      isFollowing: true,
      isFollowedBy: false,
      followedDate: '3 days ago',
    ),
  ];

  List<User> filteredFollowing = [];
  String selectedCategory = 'All';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredFollowing = List.from(following);
    _searchController.addListener(_filterFollowing);
  }

  void _filterFollowing() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      List<User> baseList = _getFilteredByCategory();

      if (query.isEmpty) {
        filteredFollowing = baseList;
      } else {
        filteredFollowing = baseList.where((user) {
          return user.username.toLowerCase().contains(query) ||
                 user.displayName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  List<User> _getFilteredByCategory() {
    switch (selectedCategory) {
      case 'Following you back':
        return following.where((user) => user.isFollowedBy).toList();
      case 'Not following back':
        return following.where((user) => !user.isFollowedBy).toList();
      case 'Recently followed':
        // Sort by most recent (in real app, use actual dates)
        List<User> recent = List.from(following);
        recent.sort((a, b) => a.followedDate.compareTo(b.followedDate));
        return recent.take(3).toList();
      default:
        return following;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Following'),
            Text(
              '${following.length} following',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: _sortFollowing,
            itemBuilder: (context) => [
              PopupMenuItem(value: 'alphabetical', child: Text('Sort A-Z')),
              PopupMenuItem(value: 'recent', child: Text('Recently followed')),
              PopupMenuItem(value: 'earliest', child: Text('Followed earliest')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search following...',
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
          // Categories
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All'),
                _buildCategoryChip('Following you back'),
                _buildCategoryChip('Not following back'),
                _buildCategoryChip('Recently followed'),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Following list
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshFollowing,
              child: ListView.builder(
                itemCount: filteredFollowing.length,
                itemBuilder: (context, index) {
                  return _buildFollowingItem(filteredFollowing[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = selectedCategory == label;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = label;
          });
          _filterFollowing();
        },
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.1),
        backgroundColor: Colors.grey[100],
        side: BorderSide(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
        ),
      ),
    );
  }

  Widget _buildFollowingItem(User user) {
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
        child: Row(
          children: [
            Text(
              user.username,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (user.isFollowedBy)
              Container(
                margin: EdgeInsets.only(left: 8),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Follows you',
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ),
          ],
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(user.displayName),
          Text(
            'Followed ${user.followedDate}',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.message, size: 20),
            onPressed: () => _sendMessage(user),
          ),
          SizedBox(width: 8),
          _buildUnfollowButton(user),
        ],
      ),
    );
  }

  Widget _buildUnfollowButton(User user) {
    return SizedBox(
      width: 90,
      height: 32,
      child: OutlinedButton(
        onPressed: () => _showUnfollowDialog(user),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Following',
          style: TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  void _showUnfollowDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(user.avatar),
            ),
            SizedBox(height: 16),
            Text(
              'Unfollow ${user.username}?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'You can always follow them again later.',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _unfollowUser(user);
            },
            child: Text(
              'Unfollow',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _unfollowUser(User user) {
    setState(() {
      following.remove(user);
      filteredFollowing.remove(user);
    });

    // Show undo option
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Unfollowed ${user.username}'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              following.add(user);
              _filterFollowing();
            });
          },
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _sortFollowing(String sortType) {
    setState(() {
      switch (sortType) {
        case 'alphabetical':
          following.sort((a, b) => a.username.compareTo(b.username));
          break;
        case 'recent':
          // In real app, sort by actual follow date
          following.sort((a, b) => a.followedDate.compareTo(b.followedDate));
          break;
        case 'earliest':
          following.sort((a, b) => b.followedDate.compareTo(a.followedDate));
          break;
      }
      _filterFollowing();
    });
  }

  Future<void> _refreshFollowing() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // In real app, fetch updated following list from server
    setState(() {
      isLoading = false;
    });
  }

  void _sendMessage(User user) {
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: user.username,
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
  final String followedDate;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.isFollowing,
    required this.isFollowedBy,
    required this.followedDate,
  });
}