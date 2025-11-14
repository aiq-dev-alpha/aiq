import 'package:flutter/material.dart';

class EventsListScreen extends StatefulWidget {
  const EventsListScreen({super.key});

  @override
  State<EventsListScreen> createState() => _EventsListScreenState();
}

class _EventsListScreenState extends State<EventsListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Event> _allEvents = [
    Event(
      id: '1',
      title: 'Flutter Dev Conference',
      description: 'Annual Flutter developer conference with latest updates and best practices.',
      date: DateTime.now().add(const Duration(days: 3)),
      location: 'San Francisco, CA',
      category: EventCategory.technology,
      attendees: 250,
      price: 299.0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Event(
      id: '2',
      title: 'Jazz Night at Blue Note',
      description: 'Experience smooth jazz with world-class musicians in an intimate setting.',
      date: DateTime.now().add(const Duration(days: 7)),
      location: 'New York, NY',
      category: EventCategory.music,
      attendees: 120,
      price: 45.0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Event(
      id: '3',
      title: 'Local Food Festival',
      description: 'Taste the best local cuisine from over 50 vendors and restaurants.',
      date: DateTime.now().add(const Duration(days: 14)),
      location: 'Austin, TX',
      category: EventCategory.food,
      attendees: 500,
      price: 25.0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Event(
      id: '4',
      title: 'Modern Art Exhibition',
      description: 'Discover contemporary artworks from emerging and established artists.',
      date: DateTime.now().add(const Duration(days: 21)),
      location: 'Los Angeles, CA',
      category: EventCategory.art,
      attendees: 150,
      price: 20.0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
    Event(
      id: '5',
      title: 'Marathon Training Workshop',
      description: 'Learn proper training techniques and nutrition for marathon running.',
      date: DateTime.now().add(const Duration(days: 10)),
      location: 'Boston, MA',
      category: EventCategory.sports,
      attendees: 75,
      price: 50.0,
      imageUrl: 'https://via.placeholder.com/300x200',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  List<Event> get _filteredEvents {
    List<Event> events;

    switch (_tabController.index) {
      case 0: // All
        events = _allEvents;
        break;
      case 1: // This Week
        final oneWeekFromNow = DateTime.now().add(const Duration(days: 7));
        events = _allEvents.where((event) => event.date.isBefore(oneWeekFromNow)).toList();
        break;
      case 2: // This Month
        final oneMonthFromNow = DateTime.now().add(const Duration(days: 30));
        events = _allEvents.where((event) => event.date.isBefore(oneMonthFromNow)).toList();
        break;
      default:
        events = _allEvents;
    }

    if (_searchQuery.isEmpty) return events;
    return events.where((event) =>
        event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        event.location.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _createEvent(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          onTap: (index) => setState(() {}),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'This Week'),
            Tab(text: 'This Month'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          // Events List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEventsList(),
                _buildEventsList(),
                _buildEventsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsList() {
    final events = _filteredEvents;

    if (events.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_available,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isEmpty ? 'No events yet' : 'No events found',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            if (_searchQuery.isEmpty) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _createEvent(),
                icon: const Icon(Icons.add),
                label: const Text('Create Event'),
              ),
            ],
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _navigateToEventDetail(event),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Event Image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        _getCategoryColor(event.category).withOpacity(0.8),
                        _getCategoryColor(event.category),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getCategoryName(event.category),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    event.location,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Event Details
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(event.date),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.people, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${event.attendees}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            event.price > 0 ? '\$${event.price.toStringAsFixed(0)}' : 'Free',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () => _registerForEvent(event),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _getCategoryColor(event.category),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Register'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.technology:
        return Colors.blue;
      case EventCategory.music:
        return Colors.purple;
      case EventCategory.food:
        return Colors.orange;
      case EventCategory.art:
        return Colors.pink;
      case EventCategory.sports:
        return Colors.green;
    }
  }

  String _getCategoryName(EventCategory category) {
    switch (category) {
      case EventCategory.technology:
        return 'Technology';
      case EventCategory.music:
        return 'Music';
      case EventCategory.food:
        return 'Food';
      case EventCategory.art:
        return 'Art';
      case EventCategory.sports:
        return 'Sports';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Tomorrow';
    } else if (difference < 7) {
      return 'In $difference days';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  void _navigateToEventDetail(Event event) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(event: event),
      ),
    );
  }

  void _registerForEvent(Event event) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Register for ${event.title}'),
        content: Text('Would you like to register for this event?\nPrice: \$${event.price.toStringAsFixed(2)}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Registered for ${event.title}!')),
              );
            },
            child: const Text('Register'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Filter options would be implemented here')),
    );
  }

  void _createEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create event functionality would be implemented here')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}

enum EventCategory {
  technology,
  music,
  food,
  art,
  sports,
}

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final EventCategory category;
  final int attendees;
  final double price;
  final String imageUrl;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    required this.category,
    required this.attendees,
    required this.price,
    required this.imageUrl,
  });
}

// This would typically be in a separate file
class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
      ),
      body: const Center(
        child: Text('Event Detail Screen'),
      ),
    );
  }
}