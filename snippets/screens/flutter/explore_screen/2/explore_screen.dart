import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;

  List<Post> trendingPosts = [
    Post(
      id: '1',
      imageUrl: 'https://example.com/trending1.jpg',
      likes: 2456,
      comments: 123,
      username: 'travel_photographer',
      isVideo: false,
      tags: ['travel', 'landscape', 'sunset'],
    ),
    Post(
      id: '2',
      imageUrl: 'https://example.com/trending2.jpg',
      likes: 1834,
      comments: 89,
      username: 'food_lover',
      isVideo: true,
      duration: '0:45',
      tags: ['food', 'recipe', 'cooking'],
    ),
    Post(
      id: '3',
      imageUrl: 'https://example.com/trending3.jpg',
      likes: 3021,
      comments: 234,
      username: 'street_artist',
      isVideo: false,
      tags: ['art', 'street', 'graffiti'],
    ),
    Post(
      id: '4',
      imageUrl: 'https://example.com/trending4.jpg',
      likes: 987,
      comments: 67,
      username: 'fitness_guru',
      isVideo: true,
      duration: '1:20',
      tags: ['fitness', 'workout', 'health'],
    ),
    Post(
      id: '5',
      imageUrl: 'https://example.com/trending5.jpg',
      likes: 1567,
      comments: 98,
      username: 'fashion_icon',
      isVideo: false,
      tags: ['fashion', 'style', 'outfit'],
    ),
    Post(
      id: '6',
      imageUrl: 'https://example.com/trending6.jpg',
      likes: 2198,
      comments: 156,
      username: 'nature_lover',
      isVideo: false,
      tags: ['nature', 'wildlife', 'photography'],
    ),
  ];

  List<String> trendingTags = [
    '#trending',
    '#photography',
    '#travel',
    '#food',
    '#fashion',
    '#fitness',
    '#art',
    '#nature',
    '#lifestyle',
    '#music',
    '#dance',
    '#comedy',
  ];

  List<User> suggestedUsers = [
    User(
      username: 'amazing_photographer',
      displayName: 'Alex Chen',
      avatar: 'https://example.com/suggested1.jpg',
      isVerified: true,
      followersCount: 125000,
    ),
    User(
      username: 'chef_master',
      displayName: 'Maria Rodriguez',
      avatar: 'https://example.com/suggested2.jpg',
      isVerified: false,
      followersCount: 85000,
    ),
    User(
      username: 'fitness_coach',
      displayName: 'John Smith',
      avatar: 'https://example.com/suggested3.jpg',
      isVerified: true,
      followersCount: 200000,
    ),
  ];

  String selectedCategory = 'All';
  List<String> categories = ['All', 'Photos', 'Videos', 'People', 'Tags'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search photos, videos, and people...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  onSubmitted: _performSearch,
                ),
              ),
              // Tab bar
              TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.black,
                isScrollable: true,
                tabs: [
                  Tab(text: 'Trending'),
                  Tab(text: 'Tags'),
                  Tab(text: 'People'),
                  Tab(text: 'Places'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTrendingTab(),
          _buildTagsTab(),
          _buildPeopleTab(),
          _buildPlacesTab(),
        ],
      ),
    );
  }

  Widget _buildTrendingTab() {
    return RefreshIndicator(
      onRefresh: _refreshTrending,
      child: CustomScrollView(
        slivers: [
          // Category filters
          SliverToBoxAdapter(
            child: Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return _buildCategoryChip(categories[index]);
                },
              ),
            ),
          ),
          // Posts grid
          SliverPadding(
            padding: EdgeInsets.all(2),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    return _buildFeaturedPost();
                  }
                  final postIndex = (index - 1) % trendingPosts.length;
                  return _buildPostTile(trendingPosts[postIndex]);
                },
                childCount: trendingPosts.length + 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagsTab() {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: trendingTags.length,
      itemBuilder: (context, index) {
        return _buildTagCard(trendingTags[index]);
      },
    );
  }

  Widget _buildPeopleTab() {
    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: suggestedUsers.length,
      separatorBuilder: (context, index) => SizedBox(height: 16),
      itemBuilder: (context, index) {
        return _buildUserCard(suggestedUsers[index]);
      },
    );
  }

  Widget _buildPlacesTab() {
    final places = [
      {'name': 'New York City', 'posts': '2.3M posts', 'image': 'https://example.com/nyc.jpg'},
      {'name': 'Tokyo', 'posts': '1.8M posts', 'image': 'https://example.com/tokyo.jpg'},
      {'name': 'Paris', 'posts': '1.5M posts', 'image': 'https://example.com/paris.jpg'},
      {'name': 'London', 'posts': '1.2M posts', 'image': 'https://example.com/london.jpg'},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return _buildPlaceCard(places[index]);
      },
    );
  }

  Widget _buildCategoryChip(String category) {
    bool isSelected = selectedCategory == category;
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = category;
          });
        },
        selectedColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.grey[100],
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildFeaturedPost() {
    return GestureDetector(
      onTap: () => _viewPost(trendingPosts.first),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              'Trending',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostTile(Post post) {
    return GestureDetector(
      onTap: () => _viewPost(post),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image, color: Colors.grey),
                );
              },
            ),
          ),
          if (post.isVideo)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white, size: 12),
                    Text(
                      post.duration ?? '',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black54],
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.favorite, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text(
                    _formatCount(post.likes),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTagCard(String tag) {
    final postCount = (tag.hashCode % 1000000).abs();

    return GestureDetector(
      onTap: () => _searchByTag(tag),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: _getTagGradient(tag),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tag,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacer(),
            Text(
              '${_formatCount(postCount)} posts',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard(User user) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.avatar),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.username,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (user.isVerified)
                        Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: Icon(Icons.verified, color: Colors.blue, size: 16),
                        ),
                    ],
                  ),
                  Text(user.displayName),
                  Text(
                    '${_formatCount(user.followersCount)} followers',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            OutlinedButton(
              onPressed: () => _followUser(user),
              child: Text('Follow'),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceCard(Map<String, String> place) {
    return GestureDetector(
      onTap: () => _searchByPlace(place['name']!),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          height: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: NetworkImage(place['image']!),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(),
                Text(
                  place['name']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  place['posts']!,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getTagGradient(String tag) {
    switch (tag.toLowerCase()) {
      case '#trending':
        return [Colors.orange, Colors.red];
      case '#photography':
        return [Colors.blue, Colors.purple];
      case '#travel':
        return [Colors.teal, Colors.blue];
      case '#food':
        return [Colors.orange, Colors.deepOrange];
      case '#fashion':
        return [Colors.pink, Colors.purple];
      case '#fitness':
        return [Colors.green, Colors.teal];
      case '#art':
        return [Colors.purple, Colors.pink];
      case '#nature':
        return [Colors.green, Colors.lightGreen];
      default:
        return [Colors.grey[600]!, Colors.grey[800]!];
    }
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }

  void _performSearch(String query) {
    if (query.trim().isNotEmpty) {
      Navigator.pushNamed(context, '/search-results', arguments: query);
    }
  }

  void _searchByTag(String tag) {
    Navigator.pushNamed(context, '/search-results', arguments: tag);
  }

  void _searchByPlace(String place) {
    Navigator.pushNamed(context, '/search-results', arguments: place);
  }

  void _viewPost(Post post) {
    Navigator.pushNamed(context, '/post-detail', arguments: post);
  }

  void _followUser(User user) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Following ${user.username}'),
        action: SnackBarAction(
          label: 'View Profile',
          onPressed: () {
            Navigator.pushNamed(context, '/user-profile', arguments: user.username);
          },
        ),
      ),
    );
  }

  Future<void> _refreshTrending() async {
    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Shuffle posts to simulate new trending content
      trendingPosts.shuffle();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }
}

class Post {
  final String id;
  final String imageUrl;
  final int likes;
  final int comments;
  final String username;
  final bool isVideo;
  final String? duration;
  final List<String> tags;

  Post({
    required this.id,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.username,
    required this.isVideo,
    this.duration,
    required this.tags,
  });
}

class User {
  final String username;
  final String displayName;
  final String avatar;
  final bool isVerified;
  final int followersCount;

  User({
    required this.username,
    required this.displayName,
    required this.avatar,
    required this.isVerified,
    required this.followersCount,
  });
}