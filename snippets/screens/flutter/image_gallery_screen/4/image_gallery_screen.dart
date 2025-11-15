import 'package:flutter/material.dart';

class GalleryTheme {
  final Color backgroundColor;
  final int gridColumns;
  final double gridSpacing;
  final double imageRadius;

  const GalleryTheme({
    this.backgroundColor = Colors.black,
    this.gridColumns = 3,
    this.gridSpacing = 4.0,
    this.imageRadius = 0.0,
  });
}

class ImageGalleryScreen extends StatelessWidget {
  final GalleryTheme? theme;
  final List<GalleryImage>? images;

  const ImageGalleryScreen({
    Key? key,
    this.theme,
    this.images,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const GalleryTheme();
    final galleryImages = images ?? _defaultImages();

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Gallery'),
        backgroundColor: Colors.black,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(effectiveTheme.gridSpacing),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: effectiveTheme.gridColumns,
          crossAxisSpacing: effectiveTheme.gridSpacing,
          mainAxisSpacing: effectiveTheme.gridSpacing,
        ),
        itemCount: galleryImages.length,
        itemBuilder: (context, index) => _ImageTile(
          image: galleryImages[index],
          theme: effectiveTheme,
          onTap: () => _openImage(context, galleryImages, index),
        ),
      ),
    );
  }

  void _openImage(BuildContext context, List<GalleryImage> images, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _ImageViewerScreen(
          images: images,
          initialIndex: index,
          theme: theme,
        ),
      ),
    );
  }

  List<GalleryImage> _defaultImages() {
    return List.generate(
      30,
      (i) => GalleryImage(
        id: 'img_$i',
        url: '',
        thumbnail: '',
      ),
    );
  }
}

class _ImageTile extends StatelessWidget {
  final GalleryImage image;
  final GalleryTheme theme;
  final VoidCallback onTap;

  const _ImageTile({
    required this.image,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.imageRadius),
        child: Container(
          color: Colors.grey[800],
          child: const Center(
            child: Icon(Icons.image, size: 48, color: Colors.white54),
          ),
        ),
      ),
    );
  }
}

class _ImageViewerScreen extends StatefulWidget {
  final List<GalleryImage> images;
  final int initialIndex;
  final GalleryTheme? theme;

  const _ImageViewerScreen({
    required this.images,
    required this.initialIndex,
    this.theme,
  });

  @override
  State<_ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<_ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('${_currentIndex + 1} / ${widget.images.length}'),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        itemCount: widget.images.length,
        itemBuilder: (context, index) => Center(
          child: Container(
            color: Colors.grey[900],
            child: const Center(
              child: Icon(Icons.image, size: 120, color: Colors.white54),
            ),
          ),
        ),
      ),
    );
  }
}

class GalleryImage {
  final String id;
  final String url;
  final String thumbnail;

  GalleryImage({
    required this.id,
    required this.url,
    required this.thumbnail,
  });
}
