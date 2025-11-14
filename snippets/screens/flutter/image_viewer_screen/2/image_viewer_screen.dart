import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageData {
  final String id;
  final String url;
  final String title;
  final String description;
  final String author;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;
  final List<String> tags;

  ImageData({
    required this.id,
    required this.url,
    required this.title,
    required this.description,
    required this.author,
    required this.createdAt,
    required this.metadata,
    required this.tags,
  });
}

class ImageViewerScreen extends StatefulWidget {
  final List<ImageData> images;
  final int initialIndex;

  const ImageViewerScreen({
    Key? key,
    required this.images,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _controlsAnimationController;
  late Animation<double> _controlsAnimation;

  int _currentIndex = 0;
  bool _showControls = true;
  bool _showInfo = false;
  bool _isZoomed = false;
  bool _isSlideshow = false;
  bool _isFavorited = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _setupAnimations();
    _checkFavoriteStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controlsAnimationController.dispose();
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

  void _checkFavoriteStatus() {
    // In a real app, check if current image is favorited
    setState(() {
      _isFavorited = false;
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      _showInfo = false;
    });

    if (_showControls) {
      _controlsAnimationController.forward();
    } else {
      _controlsAnimationController.reverse();
    }
  }

  void _toggleInfo() {
    setState(() {
      _showInfo = !_showInfo;
      if (_showInfo) {
        _showControls = true;
        _controlsAnimationController.forward();
      }
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited;
    });

    HapticFeedback.lightImpact();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorited ? 'Added to favorites' : 'Removed from favorites'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _startSlideshow() {
    setState(() {
      _isSlideshow = true;
      _showControls = false;
    });

    _controlsAnimationController.reverse();

    // Auto-advance slideshow every 3 seconds
    _runSlideshow();
  }

  void _stopSlideshow() {
    setState(() {
      _isSlideshow = false;
      _showControls = true;
    });

    _controlsAnimationController.forward();
  }

  void _runSlideshow() async {
    while (_isSlideshow && mounted) {
      await Future.delayed(const Duration(seconds: 3));
      if (_isSlideshow && mounted) {
        final nextIndex = (_currentIndex + 1) % widget.images.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  void _showImageOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _OptionTile(
                icon: Icons.share,
                title: 'Share',
                onTap: () {
                  Navigator.pop(context);
                  _shareImage();
                },
              ),
              _OptionTile(
                icon: Icons.download,
                title: 'Save to Device',
                onTap: () {
                  Navigator.pop(context);
                  _saveImage();
                },
              ),
              _OptionTile(
                icon: Icons.edit,
                title: 'Edit',
                onTap: () {
                  Navigator.pop(context);
                  _editImage();
                },
              ),
              _OptionTile(
                icon: Icons.crop,
                title: 'Crop',
                onTap: () {
                  Navigator.pop(context);
                  _cropImage();
                },
              ),
              _OptionTile(
                icon: Icons.palette,
                title: 'Filters',
                onTap: () {
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
              _OptionTile(
                icon: Icons.wallpaper,
                title: 'Set as Wallpaper',
                onTap: () {
                  Navigator.pop(context);
                  _setAsWallpaper();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Image Gallery
          PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.images.length,
            builder: (context, index) {
              final image = widget.images[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(image.url),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 3,
                heroAttributes: PhotoViewHeroAttributes(tag: image.id),
                onScaleEnd: (context, details, controllerValue) {
                  setState(() {
                    _isZoomed = controllerValue.scale! > 1.0;
                  });
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.black,
                    child: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            color: Colors.white54,
                            size: 64,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _checkFavoriteStatus();
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            loadingBuilder: (context, event) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              );
            },
          ),

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

          // Info Panel
          if (_showInfo) _buildInfoPanel(),

          // Slideshow Indicator
          if (_isSlideshow)
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, color: Colors.white, size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Slideshow',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    final currentImage = widget.images[_currentIndex];

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
                    Colors.black.withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    '${_currentIndex + 1} of ${widget.images.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          _isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: _isFavorited ? Colors.red : Colors.white,
                          size: 28,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white, size: 28),
                        onPressed: _showImageOptions,
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
                    Colors.black.withOpacity(0.8),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Title and Description
                  if (currentImage.title.isNotEmpty) ...[
                    Text(
                      currentImage.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (currentImage.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        currentImage.description,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],

                  // Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ControlButton(
                        icon: _isSlideshow ? Icons.pause : Icons.slideshow,
                        label: _isSlideshow ? 'Stop' : 'Slideshow',
                        onPressed: _isSlideshow ? _stopSlideshow : _startSlideshow,
                      ),
                      _ControlButton(
                        icon: Icons.info_outline,
                        label: 'Info',
                        onPressed: _toggleInfo,
                      ),
                      _ControlButton(
                        icon: Icons.share,
                        label: 'Share',
                        onPressed: _shareImage,
                      ),
                      _ControlButton(
                        icon: Icons.download,
                        label: 'Save',
                        onPressed: _saveImage,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Navigation Thumbnails
                  if (widget.images.length > 1) _buildThumbnailStrip(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailStrip() {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          final isSelected = index == _currentIndex;
          final image = widget.images[index];

          return GestureDetector(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Container(
              width: 60,
              height: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.transparent,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  image.url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[800],
                    child: const Icon(Icons.broken_image, color: Colors.white54),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoPanel() {
    final currentImage = widget.images[_currentIndex];

    return Positioned(
      right: 0,
      top: 0,
      bottom: 0,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
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
                    const Text(
                      'Image Info',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => setState(() => _showInfo = false),
                    ),
                  ],
                ),
              ),

              // Info Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow('Title', currentImage.title),
                      _InfoRow('Description', currentImage.description),
                      _InfoRow('Author', currentImage.author),
                      _InfoRow('Created', _formatDateTime(currentImage.createdAt)),

                      if (currentImage.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        const Text(
                          'Tags',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: currentImage.tags.map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )).toList(),
                        ),
                      ],

                      if (currentImage.metadata.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Metadata',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...currentImage.metadata.entries.map((entry) =>
                          _InfoRow(entry.key, entry.value.toString())),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _saveImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image saved to device')),
    );
  }

  void _editImage() {
    Navigator.pushNamed(context, '/image-editor', arguments: widget.images[_currentIndex]);
  }

  void _cropImage() {
    Navigator.pushNamed(context, '/image-crop', arguments: widget.images[_currentIndex]);
  }

  void _applyFilters() {
    Navigator.pushNamed(context, '/image-filters', arguments: widget.images[_currentIndex]);
  }

  void _setAsWallpaper() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Wallpaper functionality would be implemented here')),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
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

  const _OptionTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
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
    if (value.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// Sample data for testing
final sampleImages = List.generate(
  10,
  (index) => ImageData(
    id: 'image_$index',
    url: 'https://picsum.photos/800/600?random=$index',
    title: 'Beautiful Image ${index + 1}',
    description: 'This is a stunning photograph captured during a wonderful moment in time.',
    author: 'Photographer ${index % 3 + 1}',
    createdAt: DateTime.now().subtract(Duration(days: index)),
    metadata: {
      'Camera': 'Canon EOS R5',
      'Lens': 'RF 24-70mm f/2.8L IS USM',
      'ISO': '${100 + (index * 50)}',
      'Aperture': 'f/${2.8 + (index * 0.2)}',
      'Shutter Speed': '1/${60 + (index * 10)}s',
      'Resolution': '8192 x 5464',
      'File Size': '${12 + index} MB',
    },
    tags: [
      ['landscape', 'nature', 'outdoors'],
      ['portrait', 'people', 'studio'],
      ['urban', 'architecture', 'city'],
      ['macro', 'close-up', 'details'],
      ['street', 'photography', 'candid'],
    ][index % 5],
  ),
);