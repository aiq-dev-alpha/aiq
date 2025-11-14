import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = 'This Month';
  String selectedCategory = 'Sales';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          PopupMenuButton<String>(
            initialValue: selectedPeriod,
            onSelected: (value) {
              setState(() {
                selectedPeriod = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Today', child: Text('Today')),
              const PopupMenuItem(value: 'This Week', child: Text('This Week')),
              const PopupMenuItem(value: 'This Month', child: Text('This Month')),
              const PopupMenuItem(value: 'This Quarter', child: Text('This Quarter')),
              const PopupMenuItem(value: 'This Year', child: Text('This Year')),
            ],
            child: const Icon(Icons.date_range),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Users'),
            Tab(text: 'Teams'),
            Tab(text: 'Departments'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          _buildTopPerformers(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUsersTab(),
                _buildTeamsTab(),
                _buildDepartmentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selectedCategory,
                  hint: const Text('Category'),
                  items: [
                    'Sales',
                    'Performance',
                    'Engagement',
                    'Revenue',
                    'Growth',
                    'Customer Satisfaction'
                  ].map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list, size: 16),
            label: const Text('More Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPerformers() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Performers - $selectedPeriod',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPodiumCard(
                  rank: 2,
                  name: 'Sarah Wilson',
                  avatar: 'assets/avatar2.png',
                  score: '8,456',
                  change: '+12.3%',
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPodiumCard(
                  rank: 1,
                  name: 'John Smith',
                  avatar: 'assets/avatar1.png',
                  score: '9,876',
                  change: '+18.5%',
                  color: Colors.amber,
                  isWinner: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPodiumCard(
                  rank: 3,
                  name: 'Mike Johnson',
                  avatar: 'assets/avatar3.png',
                  score: '7,234',
                  change: '+8.7%',
                  color: Colors.brown.shade400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumCard({
    required int rank,
    required String name,
    required String avatar,
    required String score,
    required String change,
    required Color color,
    bool isWinner = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isWinner ? Border.all(color: Colors.amber, width: 2) : null,
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
          Stack(
            children: [
              CircleAvatar(
                radius: isWinner ? 30 : 25,
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  name.split(' ').map((n) => n[0]).join(''),
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: isWinner ? 16 : 14,
                  ),
                ),
              ),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Text(
                    rank.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              if (isWinner)
                const Positioned(
                  bottom: -5,
                  left: 0,
                  right: 0,
                  child: Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 24,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isWinner ? 14 : 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            score,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontSize: isWinner ? 16 : 14,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            change,
            style: TextStyle(
              color: Colors.green,
              fontSize: isWinner ? 12 : 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsersTab() {
    return _buildLeaderboardList(_getUsersData());
  }

  Widget _buildTeamsTab() {
    return _buildLeaderboardList(_getTeamsData());
  }

  Widget _buildDepartmentsTab() {
    return _buildLeaderboardList(_getDepartmentsData());
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildLeaderboardCard(entry, index + 4); // Starting from 4th place
      },
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry, int rank) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          _buildRankBadge(rank),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 25,
            backgroundColor: entry.color.withOpacity(0.2),
            child: entry.isTeam || entry.isDepartment
                ? Icon(
                    entry.isTeam ? Icons.group : Icons.business,
                    color: entry.color,
                  )
                : Text(
                    entry.name.split(' ').map((n) => n[0]).join(''),
                    style: TextStyle(
                      color: entry.color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (entry.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    entry.subtitle!,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _buildProgressBar(entry.progress),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                entry.score,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: entry.color,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: entry.changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  entry.change,
                  style: TextStyle(
                    color: entry.changeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    if (rank <= 5) {
      badgeColor = Colors.blue;
    } else if (rank <= 10) {
      badgeColor = Colors.green;
    } else {
      badgeColor = Colors.grey;
    }

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Progress',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<LeaderboardEntry> _getUsersData() {
    return [
      LeaderboardEntry(
        name: 'Emma Davis',
        score: '6,789',
        change: '+15.2%',
        changeColor: Colors.green,
        progress: 0.85,
        color: Colors.purple,
        subtitle: 'Senior Sales Manager',
      ),
      LeaderboardEntry(
        name: 'Alex Rodriguez',
        score: '6,234',
        change: '+12.8%',
        changeColor: Colors.green,
        progress: 0.78,
        color: Colors.orange,
        subtitle: 'Account Executive',
      ),
      LeaderboardEntry(
        name: 'Lisa Chen',
        score: '5,876',
        change: '+9.4%',
        changeColor: Colors.green,
        progress: 0.72,
        color: Colors.green,
        subtitle: 'Marketing Specialist',
      ),
      LeaderboardEntry(
        name: 'David Wilson',
        score: '5,432',
        change: '+7.1%',
        changeColor: Colors.green,
        progress: 0.68,
        color: Colors.blue,
        subtitle: 'Customer Success Manager',
      ),
      LeaderboardEntry(
        name: 'Sophie Brown',
        score: '5,123',
        change: '+5.3%',
        changeColor: Colors.green,
        progress: 0.64,
        color: Colors.red,
        subtitle: 'Business Development',
      ),
      LeaderboardEntry(
        name: 'Ryan Lee',
        score: '4,987',
        change: '+3.2%',
        changeColor: Colors.green,
        progress: 0.61,
        color: Colors.cyan,
        subtitle: 'Product Manager',
      ),
      LeaderboardEntry(
        name: 'Maria Garcia',
        score: '4,765',
        change: '+1.8%',
        changeColor: Colors.green,
        progress: 0.58,
        color: Colors.pink,
        subtitle: 'Operations Manager',
      ),
      LeaderboardEntry(
        name: 'James Taylor',
        score: '4,543',
        change: '-0.5%',
        changeColor: Colors.red,
        progress: 0.55,
        color: Colors.indigo,
        subtitle: 'Technical Lead',
      ),
    ];
  }

  List<LeaderboardEntry> _getTeamsData() {
    return [
      LeaderboardEntry(
        name: 'Alpha Team',
        score: '45,678',
        change: '+22.3%',
        changeColor: Colors.green,
        progress: 0.92,
        color: Colors.blue,
        subtitle: '12 members',
        isTeam: true,
      ),
      LeaderboardEntry(
        name: 'Beta Squad',
        score: '42,134',
        change: '+18.7%',
        changeColor: Colors.green,
        progress: 0.87,
        color: Colors.green,
        subtitle: '10 members',
        isTeam: true,
      ),
      LeaderboardEntry(
        name: 'Gamma Force',
        score: '39,876',
        change: '+15.2%',
        changeColor: Colors.green,
        progress: 0.82,
        color: Colors.orange,
        subtitle: '8 members',
        isTeam: true,
      ),
      LeaderboardEntry(
        name: 'Delta Unit',
        score: '37,543',
        change: '+12.1%',
        changeColor: Colors.green,
        progress: 0.78,
        color: Colors.purple,
        subtitle: '15 members',
        isTeam: true,
      ),
      LeaderboardEntry(
        name: 'Echo Group',
        score: '35,321',
        change: '+9.8%',
        changeColor: Colors.green,
        progress: 0.74,
        color: Colors.red,
        subtitle: '9 members',
        isTeam: true,
      ),
    ];
  }

  List<LeaderboardEntry> _getDepartmentsData() {
    return [
      LeaderboardEntry(
        name: 'Sales Department',
        score: '156,789',
        change: '+25.4%',
        changeColor: Colors.green,
        progress: 0.95,
        color: Colors.green,
        subtitle: '45 employees',
        isDepartment: true,
      ),
      LeaderboardEntry(
        name: 'Marketing Department',
        score: '134,567',
        change: '+19.8%',
        changeColor: Colors.green,
        progress: 0.89,
        color: Colors.blue,
        subtitle: '32 employees',
        isDepartment: true,
      ),
      LeaderboardEntry(
        name: 'Product Development',
        score: '128,432',
        change: '+17.2%',
        changeColor: Colors.green,
        progress: 0.86,
        color: Colors.purple,
        subtitle: '28 employees',
        isDepartment: true,
      ),
      LeaderboardEntry(
        name: 'Customer Success',
        score: '115,876',
        change: '+14.6%',
        changeColor: Colors.green,
        progress: 0.81,
        color: Colors.orange,
        subtitle: '23 employees',
        isDepartment: true,
      ),
      LeaderboardEntry(
        name: 'Operations',
        score: '98,543',
        change: '+11.3%',
        changeColor: Colors.green,
        progress: 0.76,
        color: Colors.cyan,
        subtitle: '38 employees',
        isDepartment: true,
      ),
    ];
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Region',
                border: OutlineInputBorder(),
              ),
              items: ['All Regions', 'North America', 'Europe', 'Asia Pacific']
                  .map((region) => DropdownMenuItem(
                        value: region,
                        child: Text(region),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Department',
                border: OutlineInputBorder(),
              ),
              items: ['All Departments', 'Sales', 'Marketing', 'Product', 'Support']
                  .map((dept) => DropdownMenuItem(
                        value: dept,
                        child: Text(dept),
                      ))
                  .toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Show only top performers'),
                const Spacer(),
                Switch(
                  value: false,
                  onChanged: (value) {},
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry {
  final String name;
  final String score;
  final String change;
  final Color changeColor;
  final double progress;
  final Color color;
  final String? subtitle;
  final bool isTeam;
  final bool isDepartment;

  LeaderboardEntry({
    required this.name,
    required this.score,
    required this.change,
    required this.changeColor,
    required this.progress,
    required this.color,
    this.subtitle,
    this.isTeam = false,
    this.isDepartment = false,
  });
}