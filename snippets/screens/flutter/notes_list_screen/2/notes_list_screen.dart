import 'package:flutter/material.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({super.key});

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isGridView = true;

  final List<Note> _notes = [
    Note(
      id: '1',
      title: 'Meeting Notes - Q4 Planning',
      content: 'Discussed upcoming projects, resource allocation, and timeline for Q4 deliverables. Key action items include team restructuring and budget planning.',
      category: NoteCategory.work,
      color: NoteColor.blue,
      lastModified: DateTime.now().subtract(const Duration(hours: 2)),
      isPinned: true,
    ),
    Note(
      id: '2',
      title: 'Travel Itinerary - Europe Trip',
      content: 'Day 1: London - Visit Tower Bridge, British Museum\nDay 2: Paris - Eiffel Tower, Louvre\nDay 3: Rome - Colosseum, Vatican',
      category: NoteCategory.personal,
      color: NoteColor.green,
      lastModified: DateTime.now().subtract(const Duration(days: 1)),
      isPinned: false,
    ),
    Note(
      id: '3',
      title: 'Recipe: Chocolate Chip Cookies',
      content: 'Ingredients:\n- 2 cups flour\n- 1 cup butter\n- 1/2 cup brown sugar\n- 1/2 cup white sugar\n- 2 eggs\n- 1 tsp vanilla\n- 1 cup chocolate chips',
      category: NoteCategory.personal,
      color: NoteColor.orange,
      lastModified: DateTime.now().subtract(const Duration(days: 3)),
      isPinned: false,
    ),
    Note(
      id: '4',
      title: 'Flutter Development Tips',
      content: 'Key concepts to remember:\n- State management with Provider/Riverpod\n- Widget lifecycle methods\n- Performance optimization\n- Testing strategies',
      category: NoteCategory.learning,
      color: NoteColor.purple,
      lastModified: DateTime.now().subtract(const Duration(days: 5)),
      isPinned: true,
    ),
    Note(
      id: '5',
      title: 'Book Ideas',
      content: 'Potential book topics:\n1. Time travel mystery\n2. AI consciousness thriller\n3. Historical fiction - Renaissance Italy\n4. Self-help productivity guide',
      category: NoteCategory.creative,
      color: NoteColor.pink,
      lastModified: DateTime.now().subtract(const Duration(days: 7)),
      isPinned: false,
    ),
    Note(
      id: '6',
      title: 'Workout Routine',
      content: 'Monday: Upper body\nTuesday: Cardio\nWednesday: Lower body\nThursday: Rest\nFriday: Full body\nWeekend: Yoga/stretching',
      category: NoteCategory.health,
      color: NoteColor.red,
      lastModified: DateTime.now().subtract(const Duration(days: 10)),
      isPinned: false,
    ),
  ];

  List<Note> get _filteredNotes {
    List<Note> filtered;

    if (_searchQuery.isEmpty) {
      filtered = _notes;
    } else {
      filtered = _notes.where((note) =>
          note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    // Sort: pinned notes first, then by last modified
    filtered.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.lastModified.compareTo(a.lastModified);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () => setState(() => _isGridView = !_isGridView),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
          PopupMenuButton<String>(
            onSelected: (value) => _handleMenuAction(value),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort',
                child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text('Sort'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'category',
                child: ListTile(
                  leading: Icon(Icons.category),
                  title: Text('Categories'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: ListTile(
                  leading: Icon(Icons.download),
                  title: Text('Export Notes'),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_searchQuery.isNotEmpty || _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
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

          // Category Filter
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildCategoryChip('All', null, true),
                _buildCategoryChip('Work', NoteCategory.work, false),
                _buildCategoryChip('Personal', NoteCategory.personal, false),
                _buildCategoryChip('Learning', NoteCategory.learning, false),
                _buildCategoryChip('Creative', NoteCategory.creative, false),
                _buildCategoryChip('Health', NoteCategory.health, false),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Notes Content
          Expanded(
            child: _filteredNotes.isEmpty
                ? _buildEmptyState()
                : _isGridView
                    ? _buildNotesGrid()
                    : _buildNotesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewNote(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCategoryChip(String label, NoteCategory? category, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          // In a real app, you'd filter by category here
          setState(() {});
        },
        selectedColor: Colors.blue.withOpacity(0.2),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.note_alt_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'No notes yet' : 'No notes found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          if (_searchQuery.isEmpty) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _createNewNote(),
              icon: const Icon(Icons.add),
              label: const Text('Create Note'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return _buildNoteCard(note);
      },
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        final note = _filteredNotes[index];
        return _buildNoteListItem(note);
      },
    );
  }

  Widget _buildNoteCard(Note note) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: _getNoteColorValue(note.color).withOpacity(0.1),
      child: InkWell(
        onTap: () => _navigateToNoteDetail(note),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getNoteColorValue(note.color).withOpacity(0.2),
                border: Border(
                  bottom: BorderSide(
                    color: _getNoteColorValue(note.color).withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (note.isPinned)
                    Icon(
                      Icons.push_pin,
                      size: 16,
                      color: _getNoteColorValue(note.color),
                    ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        note.content,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: Colors.grey[700],
                        ),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(note.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getCategoryName(note.category),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(note.category),
                            ),
                          ),
                        ),
                        Text(
                          _formatDate(note.lastModified),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteListItem(Note note) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _navigateToNoteDetail(note),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Color indicator
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: _getNoteColorValue(note.color),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            note.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (note.isPinned)
                          Icon(
                            Icons.push_pin,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      note.content,
                      style: TextStyle(
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(note.category).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            _getCategoryName(note.category),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _getCategoryColor(note.category),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(note.lastModified),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) => _handleNoteAction(value, note),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'pin',
                    child: ListTile(
                      leading: Icon(note.isPinned ? Icons.push_pin_outlined : Icons.push_pin),
                      title: Text(note.isPinned ? 'Unpin' : 'Pin'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'share',
                    child: ListTile(
                      leading: Icon(Icons.share),
                      title: Text('Share'),
                      dense: true,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      dense: true,
                    ),
                  ),
                ],
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSearchDialog() {
    setState(() {
      _searchController.text = _searchQuery;
    });
    // Focus search field if it's already visible, otherwise just show it
  }

  void _navigateToNoteDetail(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(note: note),
      ),
    );
  }

  void _createNewNote() {
    final newNote = Note(
      id: '${_notes.length + 1}',
      title: 'New Note',
      content: '',
      category: NoteCategory.personal,
      color: NoteColor.blue,
      lastModified: DateTime.now(),
      isPinned: false,
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteDetailScreen(note: newNote, isNew: true),
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'sort':
        _showSortOptions();
        break;
      case 'category':
        _showCategoryFilter();
        break;
      case 'export':
        _exportNotes();
        break;
    }
  }

  void _handleNoteAction(String action, Note note) {
    switch (action) {
      case 'pin':
        setState(() {
          note.isPinned = !note.isPinned;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(note.isPinned ? 'Note pinned' : 'Note unpinned'),
          ),
        );
        break;
      case 'share':
        _shareNote(note);
        break;
      case 'delete':
        _deleteNote(note);
        break;
    }
  }

  void _showSortOptions() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sort options would be implemented here')),
    );
  }

  void _showCategoryFilter() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Category filter would be implemented here')),
    );
  }

  void _exportNotes() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting notes...')),
    );
  }

  void _shareNote(Note note) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing "${note.title}"...')),
    );
  }

  void _deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Are you sure you want to delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notes.removeWhere((n) => n.id == note.id);
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Note deleted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getNoteColorValue(NoteColor color) {
    switch (color) {
      case NoteColor.blue:
        return Colors.blue;
      case NoteColor.green:
        return Colors.green;
      case NoteColor.orange:
        return Colors.orange;
      case NoteColor.purple:
        return Colors.purple;
      case NoteColor.pink:
        return Colors.pink;
      case NoteColor.red:
        return Colors.red;
    }
  }

  Color _getCategoryColor(NoteCategory category) {
    switch (category) {
      case NoteCategory.work:
        return Colors.blue;
      case NoteCategory.personal:
        return Colors.green;
      case NoteCategory.learning:
        return Colors.purple;
      case NoteCategory.creative:
        return Colors.pink;
      case NoteCategory.health:
        return Colors.red;
    }
  }

  String _getCategoryName(NoteCategory category) {
    switch (category) {
      case NoteCategory.work:
        return 'Work';
      case NoteCategory.personal:
        return 'Personal';
      case NoteCategory.learning:
        return 'Learning';
      case NoteCategory.creative:
        return 'Creative';
      case NoteCategory.health:
        return 'Health';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

enum NoteCategory { work, personal, learning, creative, health }
enum NoteColor { blue, green, orange, purple, pink, red }

class Note {
  final String id;
  final String title;
  final String content;
  final NoteCategory category;
  final NoteColor color;
  final DateTime lastModified;
  bool isPinned;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.color,
    required this.lastModified,
    required this.isPinned,
  });
}

// This would typically be in a separate file
class NoteDetailScreen extends StatelessWidget {
  final Note note;
  final bool isNew;

  const NoteDetailScreen({super.key, required this.note, this.isNew = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isNew ? 'New Note' : note.title),
      ),
      body: const Center(
        child: Text('Note Detail Screen'),
      ),
    );
  }
}