import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  bool _isRegistered = false;
  bool _isFavorite = false;
  int _selectedTickets = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _getCategoryColor(widget.event.category).withOpacity(0.8),
                          _getCategoryColor(widget.event.category),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _getCategoryName(widget.event.category),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.event.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  setState(() {
                    _isFavorite = !_isFavorite;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? 'Added to favorites'
                            : 'Removed from favorites',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handleMenuAction(value),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share Event'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'calendar',
                    child: ListTile(
                      leading: Icon(Icons.calendar_today),
                      title: Text('Add to Calendar'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'report',
                    child: ListTile(
                      leading: Icon(Icons.flag),
                      title: Text('Report Event'),
                      dense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Info Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: 'Date',
                          subtitle: _formatDate(widget.event.date),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.access_time,
                          title: 'Time',
                          subtitle: _formatTime(widget.event.date),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.location_on,
                          title: 'Location',
                          subtitle: widget.event.location,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.people,
                          title: 'Attendees',
                          subtitle: '${widget.event.attendees} registered',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  Text(
                    'About this event',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.event.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Location Map Preview
                  _buildLocationSection(),

                  const SizedBox(height: 24),

                  // Organizer Info
                  _buildOrganizerSection(),

                  const SizedBox(height: 24),

                  // Similar Events
                  _buildSimilarEventsSection(),

                  const SizedBox(height: 100), // Bottom padding for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _isRegistered
          ? FloatingActionButton.extended(
              onPressed: () => _showRegistrationDetails(),
              icon: const Icon(Icons.check),
              label: const Text('Registered'),
              backgroundColor: Colors.green,
            )
          : FloatingActionButton.extended(
              onPressed: () => _showRegistrationDialog(),
              icon: const Icon(Icons.confirmation_number),
              label: Text(widget.event.price > 0
                  ? 'Buy Tickets - \$${widget.event.price.toStringAsFixed(0)}'
                  : 'Register Free'),
              backgroundColor: _getCategoryColor(widget.event.category),
            ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              icon,
              color: _getCategoryColor(widget.event.category),
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Map Preview'),
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.location_on),
                title: Text(widget.event.location),
                trailing: const Icon(Icons.directions),
                onTap: () => _openDirections(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrganizerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Organizer',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.business, color: Colors.white),
            ),
            title: const Text(
              'Event Organizers Inc.',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('Professional event management company'),
            trailing: OutlinedButton(
              onPressed: () => _contactOrganizer(),
              child: const Text('Contact'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSimilarEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Similar Events',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          color: _getCategoryColor(widget.event.category).withOpacity(0.3),
                          child: const Center(
                            child: Icon(Icons.event, size: 40),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Similar Event ${index + 1}',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Event description...',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showRegistrationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Register for Event',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),

                if (widget.event.price > 0) ...[
                  Text(
                    'Number of tickets',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: _selectedTickets > 1
                                ? () => setModalState(() => _selectedTickets--)
                                : null,
                            icon: const Icon(Icons.remove),
                          ),
                          Text(
                            '$_selectedTickets',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: _selectedTickets < 10
                                ? () => setModalState(() => _selectedTickets++)
                                : null,
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      Text(
                        'Total: \$${(widget.event.price * _selectedTickets).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () => _completeRegistration(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getCategoryColor(widget.event.category),
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          widget.event.price > 0 ? 'Purchase' : 'Register',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _completeRegistration() {
    Navigator.of(context).pop();
    setState(() {
      _isRegistered = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully registered for ${widget.event.title}!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showRegistrationDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registration Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event: ${widget.event.title}'),
            const SizedBox(height: 8),
            Text('Date: ${_formatDate(widget.event.date)}'),
            const SizedBox(height: 8),
            Text('Location: ${widget.event.location}'),
            const SizedBox(height: 8),
            if (widget.event.price > 0)
              Text('Tickets: $_selectedTickets (\$${(widget.event.price * _selectedTickets).toStringAsFixed(2)})'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isRegistered = false;
              });
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Registration'),
          ),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareEvent();
        break;
      case 'calendar':
        _addToCalendar();
        break;
      case 'report':
        _reportEvent();
        break;
    }
  }

  void _shareEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sharing event...')),
    );
  }

  void _addToCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Adding to calendar...')),
    );
  }

  void _reportEvent() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted')),
    );
  }

  void _openDirections() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening directions...')),
    );
  }

  void _contactOrganizer() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Contacting organizer...')),
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
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $amPm';
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