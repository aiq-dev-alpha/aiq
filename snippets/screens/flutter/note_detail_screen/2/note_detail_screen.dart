import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteDetailScreen extends StatefulWidget {
  final Note note;
  final bool isNew;

  const NoteDetailScreen({super.key, required this.note, this.isNew = false});

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late NoteCategory _selectedCategory;
  late NoteColor _selectedColor;
  late bool _isPinned;

  bool _hasUnsavedChanges = false;
  bool _isFormatting = false;
  final FocusNode _contentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);
    _selectedCategory = widget.note.category;
    _selectedColor = widget.note.color;
    _isPinned = widget.note.isPinned;

    // Track changes
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    if (!_hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: _getNoteColorValue(_selectedColor).withOpacity(0.05),
        appBar: AppBar(
          title: Text(widget.isNew ? 'New Note' : 'Edit Note'),
          backgroundColor: _getNoteColorValue(_selectedColor).withOpacity(0.1),
          actions: [
            // Pin/Unpin
            IconButton(
              icon: Icon(_isPinned ? Icons.push_pin : Icons.push_pin_outlined),
              onPressed: () {
                setState(() {
                  _isPinned = !_isPinned;
                  _hasUnsavedChanges = true;
                });
              },
            ),
            // Formatting
            IconButton(
              icon: const Icon(Icons.format_paint),
              onPressed: () => setState(() => _isFormatting = !_isFormatting),
            ),
            // More options
            PopupMenuButton<String>(
              onSelected: (value) => _handleMenuAction(value),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'copy',
                  child: ListTile(
                    leading: Icon(Icons.copy),
                    title: Text('Copy to Clipboard'),
                    dense: true,
                  ),
                ),
                const PopupMenuItem(
                  value: 'export',
                  child: ListTile(
                    leading: Icon(Icons.download),
                    title: Text('Export'),
                    dense: true,
                  ),
                ),
                if (!widget.isNew)
                  const PopupMenuItem(
                    value: 'delete',
                    child: ListTile(
                      leading: Icon(Icons.delete, color: Colors.red),
                      title: Text('Delete', style: TextStyle(color: Colors.red)),
                      dense: true,
                    ),
                  ),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            // Formatting toolbar
            if (_isFormatting) _buildFormattingToolbar(),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title input
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: 'Note title...',
                        border: InputBorder.none,
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 24,
                        ),
                      ),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    // Category and color selection
                    Row(
                      children: [
                        // Category selector
                        InkWell(
                          onTap: () => _showCategorySelector(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(_selectedCategory).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getCategoryColor(_selectedCategory).withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getCategoryIcon(_selectedCategory),
                                  size: 16,
                                  color: _getCategoryColor(_selectedCategory),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getCategoryName(_selectedCategory),
                                  style: TextStyle(
                                    color: _getCategoryColor(_selectedCategory),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // Color selector
                        InkWell(
                          onTap: () => _showColorSelector(),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: _getNoteColorValue(_selectedColor),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Word count
                        Text(
                          '${_contentController.text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length} words',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Content input
                    Expanded(
                      child: TextField(
                        controller: _contentController,
                        focusNode: _contentFocusNode,
                        decoration: InputDecoration(
                          hintText: 'Start writing...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.5,
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(
              top: BorderSide(color: Colors.grey[300]!, width: 1),
            ),
          ),
          child: SafeArea(
            child: Row(
              children: [
                // Last modified
                Expanded(
                  child: Text(
                    widget.isNew
                        ? 'New note'
                        : 'Modified ${_formatLastModified(widget.note.lastModified)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ),

                // Save button
                if (_hasUnsavedChanges) ...[
                  OutlinedButton(
                    onPressed: () => _discardChanges(),
                    child: const Text('Discard'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _saveNote(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getNoteColorValue(_selectedColor),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormattingToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      child: Row(
        children: [
          _buildFormatButton(Icons.format_bold, 'Bold', () => _insertFormatting('**', '**')),
          _buildFormatButton(Icons.format_italic, 'Italic', () => _insertFormatting('*', '*')),
          _buildFormatButton(Icons.format_underlined, 'Underline', () => _insertFormatting('_', '_')),
          const VerticalDivider(width: 24),
          _buildFormatButton(Icons.format_list_bulleted, 'List', () => _insertList('• ')),
          _buildFormatButton(Icons.format_list_numbered, 'Numbered', () => _insertList('1. ')),
          const VerticalDivider(width: 24),
          _buildFormatButton(Icons.format_quote, 'Quote', () => _insertFormatting('> ', '')),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => setState(() => _isFormatting = false),
          ),
        ],
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return IconButton(
      icon: Icon(icon, size: 20),
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints(minWidth: 40),
    );
  }

  void _insertFormatting(String prefix, String suffix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid) {
      final selectedText = selection.textInside(text);
      final newText = text.replaceRange(
        selection.start,
        selection.end,
        '$prefix$selectedText$suffix',
      );

      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(
        offset: selection.start + prefix.length + selectedText.length + suffix.length,
      );
    }

    _contentFocusNode.requestFocus();
  }

  void _insertList(String prefix) {
    final text = _contentController.text;
    final selection = _contentController.selection;

    if (selection.isValid) {
      final lines = text.substring(0, selection.start).split('\n');
      final currentLineStart = text.length - lines.last.length;

      final newText = text.replaceRange(
        currentLineStart,
        currentLineStart,
        prefix,
      );

      _contentController.text = newText;
      _contentController.selection = TextSelection.collapsed(
        offset: selection.start + prefix.length,
      );
    }

    _contentFocusNode.requestFocus();
  }

  void _showCategorySelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: NoteCategory.values.map((category) {
                final isSelected = category == _selectedCategory;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                      _hasUnsavedChanges = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? _getCategoryColor(category)
                          : _getCategoryColor(category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 16,
                          color: isSelected ? Colors.white : _getCategoryColor(category),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getCategoryName(category),
                          style: TextStyle(
                            color: isSelected ? Colors.white : _getCategoryColor(category),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showColorSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Color',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: NoteColor.values.map((color) {
                final isSelected = color == _selectedColor;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedColor = color;
                      _hasUnsavedChanges = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getNoteColorValue(color),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.grey[300]!,
                        width: isSelected ? 3 : 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text('You have unsaved changes. Do you want to save before leaving?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
          ElevatedButton(
            onPressed: () {
              _saveNote();
              Navigator.of(context).pop(true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _saveNote() {
    // In a real app, this would save to a database or state management
    setState(() {
      _hasUnsavedChanges = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isNew ? 'Note created!' : 'Note saved!'),
        backgroundColor: Colors.green,
      ),
    );

    if (widget.isNew) {
      Navigator.of(context).pop();
    }
  }

  void _discardChanges() {
    setState(() {
      _titleController.text = widget.note.title;
      _contentController.text = widget.note.content;
      _selectedCategory = widget.note.category;
      _selectedColor = widget.note.color;
      _isPinned = widget.note.isPinned;
      _hasUnsavedChanges = false;
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'share':
        _shareNote();
        break;
      case 'copy':
        _copyToClipboard();
        break;
      case 'export':
        _exportNote();
        break;
      case 'delete':
        _deleteNote();
        break;
    }
  }

  void _shareNote() {
    final content = '${_titleController.text}\n\n${_contentController.text}';
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note content copied for sharing')),
    );
  }

  void _copyToClipboard() {
    final content = '${_titleController.text}\n\n${_contentController.text}';
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note copied to clipboard')),
    );
  }

  void _exportNote() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Export functionality would be implemented here')),
    );
  }

  void _deleteNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to list
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Note deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  // Helper methods
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

  IconData _getCategoryIcon(NoteCategory category) {
    switch (category) {
      case NoteCategory.work:
        return Icons.work;
      case NoteCategory.personal:
        return Icons.person;
      case NoteCategory.learning:
        return Icons.school;
      case NoteCategory.creative:
        return Icons.palette;
      case NoteCategory.health:
        return Icons.favorite;
    }
  }

  String _formatLastModified(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else {
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _contentFocusNode.dispose();
    super.dispose();
  }
}

// These enums and classes would typically be in shared files
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