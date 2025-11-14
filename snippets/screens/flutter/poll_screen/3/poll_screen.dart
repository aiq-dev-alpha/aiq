import 'package:flutter/material.dart';

class PollScreen extends StatefulWidget {
  const PollScreen({Key? key}) : super(key: key);

  @override
  State<PollScreen> createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedPollIndex = 0;
  bool _showResults = false;
  Map<String, dynamic> _userVotes = {};

  final List<Poll> _polls = [
    Poll(
      id: 'poll_1',
      title: 'Favorite Programming Language',
      description: 'Which programming language do you prefer for mobile development?',
      options: [
        PollOption(id: 'dart', text: 'Dart/Flutter', votes: 245),
        PollOption(id: 'kotlin', text: 'Kotlin', votes: 189),
        PollOption(id: 'swift', text: 'Swift', votes: 156),
        PollOption(id: 'javascript', text: 'JavaScript/React Native', votes: 203),
        PollOption(id: 'xamarin', text: 'C#/Xamarin', votes: 67),
      ],
      endDate: DateTime.now().add(const Duration(days: 7)),
      allowMultiple: false,
      isActive: true,
      category: 'Technology',
    ),
    Poll(
      id: 'poll_2',
      title: 'Work From Home Preferences',
      description: 'What is your preferred work arrangement?',
      options: [
        PollOption(id: 'full_remote', text: 'Fully remote', votes: 312),
        PollOption(id: 'hybrid', text: 'Hybrid (2-3 days office)', votes: 456),
        PollOption(id: 'mostly_office', text: 'Mostly office (1-2 days remote)', votes: 234),
        PollOption(id: 'full_office', text: 'Fully in office', votes: 123),
      ],
      endDate: DateTime.now().add(const Duration(days: 5)),
      allowMultiple: false,
      isActive: true,
      category: 'Workplace',
    ),
    Poll(
      id: 'poll_3',
      title: 'Best Mobile App Features',
      description: 'Which features are most important in a mobile app? (Select up to 3)',
      options: [
        PollOption(id: 'performance', text: 'Fast performance', votes: 423),
        PollOption(id: 'ui_design', text: 'Beautiful UI design', votes: 367),
        PollOption(id: 'offline', text: 'Offline functionality', votes: 289),
        PollOption(id: 'push_notifications', text: 'Smart notifications', votes: 234),
        PollOption(id: 'security', text: 'Strong security', votes: 445),
        PollOption(id: 'integration', text: 'Third-party integrations', votes: 178),
      ],
      endDate: DateTime.now().add(const Duration(days: 10)),
      allowMultiple: true,
      maxSelections: 3,
      isActive: true,
      category: 'Product',
    ),
    Poll(
      id: 'poll_4',
      title: 'Weekend Activity Preference',
      description: 'How do you prefer to spend your weekends?',
      options: [
        PollOption(id: 'outdoor', text: 'Outdoor activities', votes: 298),
        PollOption(id: 'reading', text: 'Reading/Learning', votes: 156),
        PollOption(id: 'socializing', text: 'Meeting friends/family', votes: 334),
        PollOption(id: 'hobbies', text: 'Personal hobbies', votes: 267),
        PollOption(id: 'rest', text: 'Relaxing at home', votes: 389),
      ],
      endDate: DateTime.now().subtract(const Duration(days: 1)),
      allowMultiple: false,
      isActive: false,
      category: 'Lifestyle',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _vote(Poll poll, List<String> selectedOptions) {
    setState(() {
      _userVotes[poll.id] = selectedOptions;
      // Simulate vote counting
      for (String optionId in selectedOptions) {
        final optionIndex = poll.options.indexWhere((option) => option.id == optionId);
        if (optionIndex != -1) {
          poll.options[optionIndex].votes++;
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Vote submitted successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _buildActivePollsTab() {
    final activePolls = _polls.where((poll) => poll.isActive).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: activePolls.length,
      itemBuilder: (context, index) {
        final poll = activePolls[index];
        return _buildPollCard(poll);
      },
    );
  }

  Widget _buildCompletedPollsTab() {
    final completedPolls = _polls.where((poll) => !poll.isActive).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: completedPolls.length,
      itemBuilder: (context, index) {
        final poll = completedPolls[index];
        return _buildPollCard(poll, showResults: true);
      },
    );
  }

  Widget _buildPollCard(Poll poll, {bool showResults = false}) {
    final hasVoted = _userVotes.containsKey(poll.id);
    final totalVotes = poll.options.fold(0, (sum, option) => sum + option.votes);
    final daysRemaining = poll.endDate.difference(DateTime.now()).inDays;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        poll.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        poll.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: poll.getCategoryColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    poll.category,
                    style: TextStyle(
                      color: poll.getCategoryColor(),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Poll info
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  '$totalVotes votes',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 4),
                Text(
                  poll.isActive
                      ? (daysRemaining > 0 ? '$daysRemaining days left' : 'Ending soon')
                      : 'Completed',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                if (poll.allowMultiple) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.check_box, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'Multiple choice',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),

            // Options
            if (!poll.isActive || showResults || hasVoted)
              _buildResultsView(poll)
            else
              _buildVotingView(poll),

            // Vote status
            if (hasVoted && poll.isActive)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'You have voted in this poll',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingView(Poll poll) {
    return _PollVotingWidget(
      poll: poll,
      onVote: _vote,
    );
  }

  Widget _buildResultsView(Poll poll) {
    final totalVotes = poll.options.fold(0, (sum, option) => sum + option.votes);

    return Column(
      children: poll.options.map((option) {
        final percentage = totalVotes > 0 ? (option.votes / totalVotes * 100) : 0;
        final isHighest = option.votes == poll.options.map((o) => o.votes).reduce((a, b) => a > b ? a : b);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      option.text,
                      style: TextStyle(
                        fontWeight: isHighest ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${option.votes}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isHighest ? Theme.of(context).primaryColor : Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${percentage.toStringAsFixed(1)}%',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isHighest ? Theme.of(context).primaryColor : Colors.grey.shade400,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Polls & Voting'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active Polls', icon: Icon(Icons.how_to_vote)),
            Tab(text: 'Results', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildActivePollsTab(),
          _buildCompletedPollsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create new poll feature coming soon!'),
            ),
          );
        },
        label: const Text('Create Poll'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _PollVotingWidget extends StatefulWidget {
  final Poll poll;
  final Function(Poll, List<String>) onVote;

  const _PollVotingWidget({
    required this.poll,
    required this.onVote,
  });

  @override
  State<_PollVotingWidget> createState() => _PollVotingWidgetState();
}

class _PollVotingWidgetState extends State<_PollVotingWidget> {
  Set<String> _selectedOptions = {};

  bool get _canVote {
    if (widget.poll.allowMultiple) {
      return _selectedOptions.isNotEmpty &&
             _selectedOptions.length <= (widget.poll.maxSelections ?? widget.poll.options.length);
    }
    return _selectedOptions.length == 1;
  }

  void _toggleOption(String optionId) {
    setState(() {
      if (widget.poll.allowMultiple) {
        if (_selectedOptions.contains(optionId)) {
          _selectedOptions.remove(optionId);
        } else if (_selectedOptions.length < (widget.poll.maxSelections ?? widget.poll.options.length)) {
          _selectedOptions.add(optionId);
        }
      } else {
        _selectedOptions.clear();
        _selectedOptions.add(optionId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...widget.poll.options.map((option) {
          final isSelected = _selectedOptions.contains(option.id);

          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => _toggleOption(option.id),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
                ),
                child: Row(
                  children: [
                    if (widget.poll.allowMultiple)
                      Icon(
                        isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
                      )
                    else
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.text,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Theme.of(context).primaryColor : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),

        if (widget.poll.allowMultiple && widget.poll.maxSelections != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Select up to ${widget.poll.maxSelections} options (${_selectedOptions.length} selected)',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _canVote
                ? () => widget.onVote(widget.poll, _selectedOptions.toList())
                : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              _selectedOptions.isEmpty
                  ? 'Select an option to vote'
                  : 'Submit Vote',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

class Poll {
  final String id;
  final String title;
  final String description;
  final List<PollOption> options;
  final DateTime endDate;
  final bool allowMultiple;
  final int? maxSelections;
  final bool isActive;
  final String category;

  Poll({
    required this.id,
    required this.title,
    required this.description,
    required this.options,
    required this.endDate,
    this.allowMultiple = false,
    this.maxSelections,
    this.isActive = true,
    required this.category,
  });

  Color getCategoryColor() {
    switch (category.toLowerCase()) {
      case 'technology':
        return Colors.blue;
      case 'workplace':
        return Colors.green;
      case 'product':
        return Colors.purple;
      case 'lifestyle':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class PollOption {
  final String id;
  final String text;
  int votes;

  PollOption({
    required this.id,
    required this.text,
    this.votes = 0,
  });
}