import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Function(List<MediaItem>)? onMediaSelected;
  final bool allowMultiple;
  final List<MediaType> allowedTypes;

  const CustomPicker({
    Key? key,
    this.onMediaSelected,
    this.allowMultiple = true,
    this.allowedTypes = const [MediaType.image, MediaType.video],
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

enum MediaType { image, video }

class MediaItem {
  final String url;
  final MediaType type;
  final String? thumbnail;

  const MediaItem({
    required this.url,
    required this.type,
    this.thumbnail,
  });
}

class _CustomPickerState extends State<CustomPicker> with SingleTickerProviderStateMixin {
  final List<MediaItem> _selectedMedia = [];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.allowedTypes.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addMedia(MediaType type) {
    setState(() {
      _selectedMedia.add(
        MediaItem(
          url: 'https://example.com/media',
          type: type,
          thumbnail: 'https://picsum.photos/200',
        ),
      );
    });
    widget.onMediaSelected?.call(_selectedMedia);
  }

  void _removeMedia(int index) {
    setState(() {
      _selectedMedia.removeAt(index);
    });
    widget.onMediaSelected?.call(_selectedMedia);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.allowedTypes.length > 1)
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey.shade600,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: widget.allowedTypes.map((type) {
                return Tab(text: type == MediaType.image ? 'Images' : 'Videos');
              }).toList(),
            ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: TabBarView(
              controller: _tabController,
              children: widget.allowedTypes.map((type) {
                return _buildMediaGrid(type);
              }).toList(),
            ),
          ),
          if (_selectedMedia.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_selectedMedia.length, (index) {
                final item = _selectedMedia[index];
                return Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: item.thumbnail != null
                            ? DecorationImage(
                                image: NetworkImage(item.thumbnail!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: item.type == MediaType.video
                          ? const Center(
                              child: Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 32,
                              ),
                            )
                          : null,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removeMedia(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMediaGrid(MediaType type) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () => _addMedia(type),
        icon: Icon(type == MediaType.image ? Icons.image : Icons.videocam),
        label: Text('Add ${type == MediaType.image ? 'Image' : 'Video'}'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }
}
