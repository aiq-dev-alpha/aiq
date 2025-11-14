import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFDocument {
  final String id;
  final String title;
  final String filePath;
  final String author;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int totalPages;
  final double fileSizeInMB;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  PDFDocument({
    required this.id,
    required this.title,
    required this.filePath,
    required this.author,
    required this.createdAt,
    required this.modifiedAt,
    required this.totalPages,
    required this.fileSizeInMB,
    required this.tags,
    required this.metadata,
  });
}

class PDFViewerScreen extends StatefulWidget {
  final PDFDocument document;

  const PDFViewerScreen({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  State<PDFViewerScreen> createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen>
    with TickerProviderStateMixin {
  late PDFViewController _pdfController;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  int _currentPage = 1;
  int _totalPages = 0;
  bool _isReady = false;
  bool _showControls = true;
  bool _isNightMode = false;
  bool _showOutline = false;
  bool _showAnnotations = false;
  bool _isBookmarked = false;
  double _zoomLevel = 1.0;
  String _errorMessage = '';

  final TextEditingController _pageController = TextEditingController();
  final List<String> _bookmarks = [];
  final List<String> _annotations = [];
  final List<String> _outline = [];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadDocumentOutline();
    _checkBookmarkStatus();
  }

  @override
  void dispose() {
    _controlsAnimationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _setupAnimations() {
    _controlsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _controlsAnimation = CurvedAnimation(
      parent: _controlsAnimationController,
      curve: Curves.easeInOut,
    );

    _controlsAnimationController.forward();
  }

  void _loadDocumentOutline() {
    // Simulate loading document outline
    setState(() {
      _outline.addAll([
        'Chapter 1: Introduction',
        'Chapter 2: Getting Started',
        'Chapter 3: Advanced Topics',
        'Chapter 4: Best Practices',
        'Chapter 5: Conclusion',
        'Appendix A: Reference',
        'Appendix B: Glossary',
      ]);
    });
  }

  void _checkBookmarkStatus() {
    // Check if current document is bookmarked
    setState(() {
      _isBookmarked = false; // Load from storage
    });
  }

  void _onPDFViewCreated(PDFViewController controller) {
    _pdfController = controller;
    setState(() {
      _isReady = true;
    });
  }

  void _onPageChanged(int? page, int? total) {
    if (page != null && total != null) {
      setState(() {
        _currentPage = page + 1;
        _totalPages = total;
      });
    }
  }

  void _onError(dynamic error) {
    setState(() {
      _errorMessage = error.toString();
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      _showOutline = false;
      _showAnnotations = false;
    });

    if (_showControls) {
      _controlsAnimationController.forward();
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _toggleNightMode() {
    setState(() {
      _isNightMode = !_isNightMode;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isBookmarked ? 'Document bookmarked' : 'Bookmark removed'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _goToPage(int page) {
    if (page >= 1 && page <= _totalPages) {
      _pdfController.setPage(page - 1);
    }
  }

  void _nextPage() {
    if (_currentPage < _totalPages) {
      _pdfController.setPage(_currentPage);
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _pdfController.setPage(_currentPage - 2);
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel = (_zoomLevel * 1.2).clamp(0.5, 3.0);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel = (_zoomLevel / 1.2).clamp(0.5, 3.0);
    });
  }

  void _resetZoom() {
    setState(() {
      _zoomLevel = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isNightMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          // PDF Viewer
          if (_errorMessage.isNotEmpty)
            _buildErrorView()
          else
            _buildPDFView(),

          // Tap detector for showing/hiding controls
          GestureDetector(
            onTap: _toggleControls,
            behavior: HitTestBehavior.translucent,
            child: Container(),
          ),

          // Controls Overlay
          AnimatedBuilder(
            animation: _controlsAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _controlsAnimation.value,
                child: _showControls ? _buildControls() : const SizedBox(),
              );
            },
          ),

          // Outline Panel
          if (_showOutline) _buildOutlinePanel(),

          // Annotations Panel
          if (_showAnnotations) _buildAnnotationsPanel(),
        ],
      ),
    );
  }

  Widget _buildPDFView() {
    return PDFView(
      filePath: widget.document.filePath,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: false,
      pageFling: true,
      pageSnap: true,
      defaultPage: _currentPage - 1,
      fitPolicy: FitPolicy.WIDTH,
      preventLinkNavigation: false,
      onRender: (pages) {
        setState(() {
          _totalPages = pages ?? 0;
        });
      },
      onError: _onError,
      onPageError: (page, error) {
        print('Page $page: ${error.toString()}');
      },
      onViewCreated: _onPDFViewCreated,
      onLinkHandler: (uri) {
        print('goto link: $uri');
      },
      onPageChanged: _onPageChanged,
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Failed to load PDF',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _errorMessage = '';
              });
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Stack(
      children: [
        // Top Bar
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    (_isNightMode ? Colors.black : Colors.white).withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: _isNightMode ? Colors.white : Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.document.title,
                          style: TextStyle(
                            color: _isNightMode ? Colors.white : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'by ${widget.document.author}',
                          style: TextStyle(
                            color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: _isBookmarked ? Colors.blue : (_isNightMode ? Colors.white : Colors.black),
                        ),
                        onPressed: _toggleBookmark,
                      ),
                      IconButton(
                        icon: Icon(
                          _isNightMode ? Icons.light_mode : Icons.dark_mode,
                          color: _isNightMode ? Colors.white : Colors.black,
                        ),
                        onPressed: _toggleNightMode,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.more_vert,
                          color: _isNightMode ? Colors.white : Colors.black,
                        ),
                        onPressed: _showDocumentOptions,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Bottom Bar
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    (_isNightMode ? Colors.black : Colors.white).withOpacity(0.9),
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Navigation
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.chevron_left,
                          color: _isNightMode ? Colors.white : Colors.black,
                        ),
                        onPressed: _currentPage > 1 ? _previousPage : null,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _showGoToPageDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            decoration: BoxDecoration(
                              color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '$_currentPage of $_totalPages',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _isNightMode ? Colors.white : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.chevron_right,
                          color: _isNightMode ? Colors.white : Colors.black,
                        ),
                        onPressed: _currentPage < _totalPages ? _nextPage : null,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: Icons.list,
                        label: 'Outline',
                        isActive: _showOutline,
                        onPressed: () {
                          setState(() {
                            _showOutline = !_showOutline;
                            _showAnnotations = false;
                          });
                        },
                        nightMode: _isNightMode,
                      ),
                      _ControlButton(
                        icon: Icons.note,
                        label: 'Notes',
                        isActive: _showAnnotations,
                        onPressed: () {
                          setState(() {
                            _showAnnotations = !_showAnnotations;
                            _showOutline = false;
                          });
                        },
                        nightMode: _isNightMode,
                      ),
                      _ControlButton(
                        icon: Icons.zoom_in,
                        label: 'Zoom+',
                        onPressed: _zoomIn,
                        nightMode: _isNightMode,
                      ),
                      _ControlButton(
                        icon: Icons.zoom_out,
                        label: 'Zoom-',
                        onPressed: _zoomOut,
                        nightMode: _isNightMode,
                      ),
                      _ControlButton(
                        icon: Icons.search,
                        label: 'Search',
                        onPressed: _showSearchDialog,
                        nightMode: _isNightMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOutlinePanel() {
    return Positioned(
      left: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 280,
        decoration: BoxDecoration(
          color: (_isNightMode ? Colors.black : Colors.white).withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Table of Contents',
                      style: TextStyle(
                        color: _isNightMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: _isNightMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() => _showOutline = false),
                    ),
                  ],
                ),
              ),

              // Outline List
              Expanded(
                child: ListView.builder(
                  itemCount: _outline.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        _outline[index],
                        style: TextStyle(
                          color: _isNightMode ? Colors.white : Colors.black,
                        ),
                      ),
                      leading: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      onTap: () {
                        // Navigate to chapter page
                        _goToPage((index + 1) * 5); // Simulate chapter pages
                        setState(() => _showOutline = false);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnnotationsPanel() {
    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: (_isNightMode ? Colors.black : Colors.white).withOpacity(0.95),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(-2, 0),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Annotations',
                      style: TextStyle(
                        color: _isNightMode ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: _isNightMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () => setState(() => _showAnnotations = false),
                    ),
                  ],
                ),
              ),

              // Annotations List
              Expanded(
                child: _annotations.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.note_outlined,
                              size: 48,
                              color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.5),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No annotations yet',
                              style: TextStyle(
                                color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tap and hold on text to add notes',
                              style: TextStyle(
                                color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.5),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _annotations.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            color: _isNightMode ? Colors.grey[800] : Colors.grey[100],
                            child: ListTile(
                              title: Text(
                                'Page ${index + 1} Annotation',
                                style: TextStyle(
                                  color: _isNightMode ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              subtitle: Text(
                                'Sample annotation text here...',
                                style: TextStyle(
                                  color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.7),
                                ),
                              ),
                              onTap: () {
                                // Navigate to annotated page
                                _goToPage(index + 1);
                                setState(() => _showAnnotations = false);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoToPageDialog() {
    _pageController.text = _currentPage.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Go to Page'),
        content: TextField(
          controller: _pageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter page number (1-$_totalPages)',
            border: const OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(_pageController.text);
              if (page != null && page >= 1 && page <= _totalPages) {
                _goToPage(page);
                Navigator.pop(context);
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search in Document'),
        content: const TextField(
          decoration: InputDecoration(
            hintText: 'Enter search terms...',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search functionality would be implemented here')),
              );
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showDocumentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: _isNightMode ? Colors.grey[900] : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: (_isNightMode ? Colors.white : Colors.black).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _OptionTile(
                icon: Icons.info_outline,
                title: 'Document Info',
                onTap: () {
                  Navigator.pop(context);
                  _showDocumentInfo();
                },
                nightMode: _isNightMode,
              ),
              _OptionTile(
                icon: Icons.share,
                title: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  _shareDocument();
                },
                nightMode: _isNightMode,
              ),
              _OptionTile(
                icon: Icons.print,
                title: 'Print',
                onTap: () {
                  Navigator.pop(context);
                  _printDocument();
                },
                nightMode: _isNightMode,
              ),
              _OptionTile(
                icon: Icons.text_fields,
                title: 'Text Size',
                onTap: () {
                  Navigator.pop(context);
                  _showTextSizeDialog();
                },
                nightMode: _isNightMode,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showDocumentInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Information'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoRow('Title', widget.document.title),
              _InfoRow('Author', widget.document.author),
              _InfoRow('Pages', widget.document.totalPages.toString()),
              _InfoRow('File Size', '${widget.document.fileSizeInMB.toStringAsFixed(1)} MB'),
              _InfoRow('Created', _formatDate(widget.document.createdAt)),
              _InfoRow('Modified', _formatDate(widget.document.modifiedAt)),
              if (widget.document.tags.isNotEmpty)
                _InfoRow('Tags', widget.document.tags.join(', ')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showTextSizeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Text Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Small', 'Medium', 'Large', 'Extra Large']
              .map((size) => RadioListTile<String>(
                    title: Text(size),
                    value: size,
                    groupValue: 'Medium',
                    onChanged: (value) {
                      Navigator.pop(context);
                      // Implement text size change
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _shareDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _printDocument() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Print functionality would be implemented here')),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onPressed;
  final bool nightMode;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    required this.onPressed,
    this.nightMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : (nightMode ? Colors.white : Colors.black);

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool nightMode;

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.nightMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: nightMode ? Colors.white : Colors.black,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: nightMode ? Colors.white : Colors.black,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

// Sample data for testing
final samplePDFDocument = PDFDocument(
  id: 'doc_1',
  title: 'Flutter Development Guide',
  filePath: '/path/to/flutter-guide.pdf',
  author: 'Flutter Team',
  createdAt: DateTime.now().subtract(const Duration(days: 30)),
  modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
  totalPages: 150,
  fileSizeInMB: 12.5,
  tags: ['flutter', 'mobile', 'development', 'guide'],
  metadata: {
    'Subject': 'Mobile App Development',
    'Keywords': 'Flutter, Dart, Mobile, UI',
    'Creator': 'Adobe Acrobat',
    'Producer': 'Flutter Documentation Team',
  },
);