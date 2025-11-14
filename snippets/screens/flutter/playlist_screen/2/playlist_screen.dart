import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AudioTrack {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final Duration duration;
  final bool isDownloaded;

  AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.duration,
    this.isDownloaded = false,
  });
}

class Playlist {
  final String id;
  final String name;
  final String description;
  final String coverUrl;
  final List<AudioTrack> tracks;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublic;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.coverUrl,
    required this.tracks,
    required this.createdAt,
    required this.updatedAt,
    this.isPublic = false,
  });

  Duration get totalDuration =>
      tracks.fold(Duration.zero, (sum, track) => sum + track.duration);

  int get downloadedCount =>
      tracks.where((track) => track.isDownloaded).length;
}

class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;

  const PlaylistScreen({
    Key? key,
    required this.playlist,
  }) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  late Playlist _playlist;
  bool _isShuffleEnabled = false;
  bool _isPlaying = false;
  int _currentTrackIndex = -1;
  bool _isEditMode = false;
  final Set<int> _selectedTracks = {};

  @override
  void initState() {
    super.initState();
    _playlist = widget.playlist;
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffleEnabled = !_isShuffleEnabled;
    });
    HapticFeedback.lightImpact();
  }

  void _playPlaylist({bool shuffle = false}) {
    setState(() {
      _isPlaying = true;
      _currentTrackIndex = shuffle ? 0 : 0; // In real app, would shuffle
      _isShuffleEnabled = shuffle;
    });

    // Navigate to audio player with the first track
    Navigator.pushNamed(
      context,
      '/audio-player',
      arguments: {
        'track': _playlist.tracks[_currentTrackIndex],
        'playlist': _playlist.tracks,
      },
    );
  }

  void _playTrack(int index) {
    setState(() {
      _currentTrackIndex = index;
      _isPlaying = true;
    });

    Navigator.pushNamed(
      context,
      '/audio-player',
      arguments: {
        'track': _playlist.tracks[index],
        'playlist': _playlist.tracks,
      },
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
      if (!_isEditMode) {
        _selectedTracks.clear();
      }
    });
  }

  void _toggleTrackSelection(int index) {
    setState(() {
      if (_selectedTracks.contains(index)) {
        _selectedTracks.remove(index);
      } else {
        _selectedTracks.add(index);
      }
    });
  }

  void _deleteSelectedTracks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Tracks'),
        content: Text(
          'Are you sure you want to remove ${_selectedTracks.length} track(s) from this playlist?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                final indicesToRemove = _selectedTracks.toList()..sort((a, b) => b.compareTo(a));
                for (final index in indicesToRemove) {
                  _playlist.tracks.removeAt(index);
                }
                _selectedTracks.clear();
                _isEditMode = false;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tracks removed from playlist')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showPlaylistOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showEditPlaylistDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Download All'),
              onTap: () {
                Navigator.pop(context);
                _downloadAllTracks();
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Playlist'),
              onTap: () {
                Navigator.pop(context);
                _sharePlaylist();
              },
            ),
            ListTile(
              leading: Icon(
                _playlist.isPublic ? Icons.public_off : Icons.public,
              ),
              title: Text(_playlist.isPublic ? 'Make Private' : 'Make Public'),
              onTap: () {
                Navigator.pop(context);
                _togglePlaylistVisibility();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Playlist', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeletePlaylistDialog();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Playlist Header
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              if (_isEditMode && _selectedTracks.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: _deleteSelectedTracks,
                )
              else ...[
                IconButton(
                  icon: Icon(_isEditMode ? Icons.done : Icons.edit),
                  onPressed: _toggleEditMode,
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: _showPlaylistOptions,
                ),
              ],
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.purple.withOpacity(0.8),
                      Colors.purple.withOpacity(0.4),
                      Theme.of(context).colorScheme.surface,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Playlist Cover
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: _playlist.coverUrl.isNotEmpty
                                  ? Image.network(
                                      _playlist.coverUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          _buildDefaultCover(),
                                    )
                                  : _buildDefaultCover(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _playlist.name,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_playlist.tracks.length} tracks • ${_formatDuration(_playlist.totalDuration)}',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                                if (_playlist.downloadedCount > 0) ...[
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.download_done,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${_playlist.downloadedCount} downloaded',
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),

                      if (_playlist.description.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          _playlist.description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Control Buttons
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _playlist.tracks.isNotEmpty
                          ? () => _playPlaylist()
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Play'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _playlist.tracks.isNotEmpty
                          ? () => _playPlaylist(shuffle: true)
                          : null,
                      icon: const Icon(Icons.shuffle),
                      label: const Text('Shuffle'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Track List
          if (_playlist.tracks.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyPlaylist(),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _TrackListItem(
                  track: _playlist.tracks[index],
                  index: index,
                  isPlaying: _currentTrackIndex == index && _isPlaying,
                  isEditMode: _isEditMode,
                  isSelected: _selectedTracks.contains(index),
                  onTap: _isEditMode
                      ? () => _toggleTrackSelection(index)
                      : () => _playTrack(index),
                  onLongPress: () => _showTrackOptions(_playlist.tracks[index], index),
                ),
                childCount: _playlist.tracks.length,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDefaultCover() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withOpacity(0.8),
            Colors.blue.withOpacity(0.8),
          ],
        ),
      ),
      child: const Icon(
        Icons.queue_music,
        size: 48,
        color: Colors.white,
      ),
    );
  }

  Widget _buildEmptyPlaylist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.music_note,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Your playlist is empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add some tracks to get started',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/music-library'),
            icon: const Icon(Icons.add),
            label: const Text('Add Music'),
          ),
        ],
      ),
    );
  }

  void _showTrackOptions(AudioTrack track, int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play'),
              onTap: () {
                Navigator.pop(context);
                _playTrack(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('Add to Another Playlist'),
              onTap: () {
                Navigator.pop(context);
                _showAddToPlaylistDialog(track);
              },
            ),
            ListTile(
              leading: Icon(track.isDownloaded ? Icons.download_done : Icons.download),
              title: Text(track.isDownloaded ? 'Downloaded' : 'Download'),
              onTap: track.isDownloaded
                  ? null
                  : () {
                      Navigator.pop(context);
                      _downloadTrack(track);
                    },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {
                Navigator.pop(context);
                _shareTrack(track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline, color: Colors.red),
              title: const Text('Remove from Playlist', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _removeTrackFromPlaylist(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPlaylistDialog() {
    final nameController = TextEditingController(text: _playlist.name);
    final descController = TextEditingController(text: _playlist.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Playlist Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _playlist = Playlist(
                  id: _playlist.id,
                  name: nameController.text.trim(),
                  description: descController.text.trim(),
                  coverUrl: _playlist.coverUrl,
                  tracks: _playlist.tracks,
                  createdAt: _playlist.createdAt,
                  updatedAt: DateTime.now(),
                  isPublic: _playlist.isPublic,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Playlist updated')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddToPlaylistDialog(AudioTrack track) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add to Playlist'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Create New Playlist'),
              leading: const Icon(Icons.add),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ...['My Favorites', 'Workout Mix', 'Chill Vibes'].map(
              (playlist) => ListTile(
                title: Text(playlist),
                leading: const Icon(Icons.queue_music),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to $playlist')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeletePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Playlist'),
        content: Text('Are you sure you want to delete "${_playlist.name}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to previous screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Playlist deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _downloadAllTracks() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading all tracks...')),
    );
  }

  void _sharePlaylist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _togglePlaylistVisibility() {
    setState(() {
      _playlist = Playlist(
        id: _playlist.id,
        name: _playlist.name,
        description: _playlist.description,
        coverUrl: _playlist.coverUrl,
        tracks: _playlist.tracks,
        createdAt: _playlist.createdAt,
        updatedAt: DateTime.now(),
        isPublic: !_playlist.isPublic,
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_playlist.isPublic ? 'Playlist is now public' : 'Playlist is now private'),
      ),
    );
  }

  void _downloadTrack(AudioTrack track) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading "${track.title}"...')),
    );
  }

  void _shareTrack(AudioTrack track) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality would be implemented here')),
    );
  }

  void _removeTrackFromPlaylist(int index) {
    final trackTitle = _playlist.tracks[index].title;
    setState(() {
      _playlist.tracks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed "$trackTitle" from playlist')),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '$hours hr $minutes min';
    } else {
      return '$minutes min';
    }
  }
}

class _TrackListItem extends StatelessWidget {
  final AudioTrack track;
  final int index;
  final bool isPlaying;
  final bool isEditMode;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _TrackListItem({
    required this.track,
    required this.index,
    required this.isPlaying,
    required this.isEditMode,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: isEditMode
          ? Checkbox(
              value: isSelected,
              onChanged: (_) => onTap(),
            )
          : SizedBox(
              width: 48,
              height: 48,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.network(
                      track.coverUrl,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 48,
                        height: 48,
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        child: const Icon(Icons.music_note, size: 24),
                      ),
                    ),
                  ),
                  if (isPlaying)
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(
                        Icons.equalizer,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
      title: Text(
        track.title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
          color: isPlaying ? Theme.of(context).colorScheme.primary : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${track.artist} • ${track.album}',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (track.isDownloaded)
            Icon(
              Icons.download_done,
              size: 16,
              color: Colors.green,
            ),
          const SizedBox(width: 8),
          Text(
            _formatDuration(track.duration),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          if (!isEditMode)
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onLongPress,
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
      onTap: onTap,
      onLongPress: isEditMode ? null : onLongPress,
      selected: isSelected,
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }
}

// Sample data
final samplePlaylist = Playlist(
  id: 'playlist_1',
  name: 'My Favorites',
  description: 'A collection of my most loved tracks from various genres',
  coverUrl: 'https://picsum.photos/300/300?random=1',
  createdAt: DateTime.now().subtract(const Duration(days: 30)),
  updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  isPublic: false,
  tracks: List.generate(
    15,
    (index) => AudioTrack(
      id: 'track_$index',
      title: 'Amazing Song ${index + 1}',
      artist: ['Artist A', 'Artist B', 'Artist C'][index % 3],
      album: ['Album X', 'Album Y', 'Album Z'][index % 3],
      coverUrl: 'https://picsum.photos/100/100?random=$index',
      duration: Duration(minutes: 3 + (index % 4), seconds: (index * 15) % 60),
      isDownloaded: index % 4 == 0,
    ),
  ),
);