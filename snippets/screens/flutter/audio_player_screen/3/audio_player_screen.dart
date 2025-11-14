import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioTrack {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String coverUrl;
  final String audioUrl;
  final Duration duration;
  final List<String> genres;

  AudioTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.coverUrl,
    required this.audioUrl,
    required this.duration,
    required this.genres,
  });
}

class AudioPlayerScreen extends StatefulWidget {
  final AudioTrack track;
  final List<AudioTrack>? playlist;

  const AudioPlayerScreen({
    Key? key,
    required this.track,
    this.playlist,
  }) : super(key: key);

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late AnimationController _rotationController;
  late AnimationController _waveController;
  late Animation<double> _rotationAnimation;
  late List<Animation<double>> _waveAnimations;

  bool _isPlaying = false;
  bool _isShuffle = false;
  bool _isRepeat = false;
  bool _isLiked = false;
  bool _showLyrics = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _playbackSpeed = 1.0;

  int _currentTrackIndex = 0;
  late List<AudioTrack> _playlist;
  AudioTrack get _currentTrack => _playlist[_currentTrackIndex];

  final List<String> _sampleLyrics = [
    '[00:00] Welcome to this amazing song',
    '[00:15] The melody flows so beautifully',
    '[00:30] With every note and every beat',
    '[00:45] Music brings us together',
    '[01:00] In harmony we find our peace',
    '[01:15] Let the rhythm take control',
    '[01:30] Feel the music in your soul',
    '[01:45] This is where we belong',
  ];

  @override
  void initState() {
    super.initState();
    _initializeAudio();
    _setupAnimations();
    _playlist = widget.playlist ?? [widget.track];
    _currentTrackIndex = _playlist.indexWhere((track) => track.id == widget.track.id);
    if (_currentTrackIndex == -1) _currentTrackIndex = 0;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _rotationController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _initializeAudio() {
    _audioPlayer = AudioPlayer();

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });

        if (_isPlaying) {
          _rotationController.repeat();
          _waveController.repeat();
        } else {
          _rotationController.stop();
          _waveController.stop();
        }
      }
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _currentPosition = position;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    _loadTrack();
  }

  void _setupAnimations() {
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotationController);

    // Create wave animations for visualizer
    _waveAnimations = List.generate(
      5,
      (index) => Tween<double>(
        begin: 0.1,
        end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: _waveController,
          curve: Interval(
            index * 0.1,
            0.5 + (index * 0.1),
            curve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }

  Future<void> _loadTrack() async {
    try {
      await _audioPlayer.setSourceUrl(_currentTrack.audioUrl);
    } catch (e) {
      debugPrint('Error loading track: $e');
    }
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  void _seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void _playNext() {
    if (_isShuffle) {
      _currentTrackIndex = (_currentTrackIndex + 1 + (DateTime.now().millisecond % _playlist.length)) % _playlist.length;
    } else {
      _currentTrackIndex = (_currentTrackIndex + 1) % _playlist.length;
    }
    setState(() {});
    _loadTrack();
  }

  void _playPrevious() {
    _currentTrackIndex = (_currentTrackIndex - 1 + _playlist.length) % _playlist.length;
    setState(() {});
    _loadTrack();
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffle = !_isShuffle;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleRepeat() {
    setState(() {
      _isRepeat = !_isRepeat;
    });
    HapticFeedback.lightImpact();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple.withOpacity(0.3),
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 32),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Column(
                      children: [
                        const Text(
                          'PLAYING FROM',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          _currentTrack.album,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: _showMoreOptions,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Album Cover with Visualizer
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Visualizer Background
                      if (_isPlaying) _buildVisualizer(),

                      // Rotating Album Cover
                      AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value * 2 * 3.14159,
                            child: Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  _currentTrack.coverUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey[800],
                                    child: const Icon(
                                      Icons.music_note,
                                      size: 80,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // Track Info
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Track Title and Artist
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _currentTrack.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _currentTrack.artist,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              _isLiked ? Icons.favorite : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.white70,
                              size: 28,
                            ),
                            onPressed: _toggleLike,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Progress Bar
                      Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 3,
                              thumbRadius: 6,
                              overlayRadius: 12,
                              activeTrackColor: Colors.white,
                              inactiveTrackColor: Colors.white.withOpacity(0.3),
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: _totalDuration.inMilliseconds > 0
                                  ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
                                  : 0.0,
                              onChanged: (value) {
                                final position = Duration(
                                  milliseconds: (value * _totalDuration.inMilliseconds).round(),
                                );
                                _seekTo(position);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_totalDuration),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isShuffle ? Icons.shuffle : Icons.shuffle,
                              color: _isShuffle ? Colors.green : Colors.white70,
                              size: 24,
                            ),
                            onPressed: _toggleShuffle,
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: _playPrevious,
                          ),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 32,
                              ),
                              onPressed: _togglePlayPause,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 36,
                            ),
                            onPressed: _playNext,
                          ),
                          IconButton(
                            icon: Icon(
                              _isRepeat ? Icons.repeat_one : Icons.repeat,
                              color: _isRepeat ? Colors.green : Colors.white70,
                              size: 24,
                            ),
                            onPressed: _toggleRepeat,
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Bottom Actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.devices, color: Colors.white70),
                            onPressed: _showDevices,
                          ),
                          IconButton(
                            icon: const Icon(Icons.queue_music, color: Colors.white70),
                            onPressed: () => Navigator.pushNamed(context, '/playlist'),
                          ),
                          IconButton(
                            icon: Icon(
                              _showLyrics ? Icons.lyrics : Icons.lyrics_outlined,
                              color: _showLyrics ? Colors.green : Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _showLyrics = !_showLyrics;
                              });
                            },
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
      ),
      bottomSheet: _showLyrics ? _buildLyricsSheet() : null,
    );
  }

  Widget _buildVisualizer() {
    return Container(
      width: 320,
      height: 320,
      child: AnimatedBuilder(
        animation: _waveController,
        builder: (context, child) {
          return CustomPaint(
            painter: _VisualizerPainter(_waveAnimations),
          );
        },
      ),
    );
  }

  Widget _buildLyricsSheet() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.9),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Lyrics',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _sampleLyrics.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    _sampleLyrics[index].split('] ').last,
                    style: TextStyle(
                      color: index == 2 ? Colors.white : Colors.white70,
                      fontSize: 16,
                      fontWeight: index == 2 ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreOptions() {
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
              ListTile(
                leading: const Icon(Icons.playlist_add, color: Colors.white),
                title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showPlaylistDialog();
                },
              ),
              ListTile(
                leading: const Icon(Icons.download, color: Colors.white),
                title: const Text('Download', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _downloadTrack();
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.white),
                title: const Text('Share', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _shareTrack();
                },
              ),
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.white),
                title: Text('Playback Speed: ${_playbackSpeed}x',
                    style: const TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showSpeedDialog();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  void _showDevices() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Connect to Device', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.smartphone, color: Colors.white),
              title: const Text('This Device', style: TextStyle(color: Colors.white)),
              trailing: const Icon(Icons.check, color: Colors.green),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.speaker, color: Colors.white),
              title: const Text('Living Room Speaker', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.headset, color: Colors.white),
              title: const Text('Bluetooth Headphones', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Add to Playlist', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add, color: Colors.white),
              title: const Text('Create New Playlist', style: TextStyle(color: Colors.white)),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(color: Colors.white24),
            ...['Favorites', 'Workout', 'Chill', 'Party'].map(
              (playlist) => ListTile(
                leading: const Icon(Icons.queue_music, color: Colors.white),
                title: Text(playlist, style: const TextStyle(color: Colors.white)),
                onTap: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Playback Speed', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0]
              .map((speed) => RadioListTile<double>(
                    title: Text('${speed}x', style: const TextStyle(color: Colors.white)),
                    value: speed,
                    groupValue: _playbackSpeed,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        _playbackSpeed = value!;
                      });
                      _audioPlayer.setPlaybackRate(value!);
                      Navigator.pop(context);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  void _downloadTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Download started'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _shareTrack() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality would be implemented here'),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60);
    return '$minutes:${twoDigits(seconds)}';
  }
}

class _VisualizerPainter extends CustomPainter {
  final List<Animation<double>> waveAnimations;

  _VisualizerPainter(this.waveAnimations);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Draw concentric circles that pulse with the music
    for (int i = 0; i < waveAnimations.length; i++) {
      final radius = (size.width / 2 - 40) * waveAnimations[i].value;
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Sample data
final sampleAudioTrack = AudioTrack(
  id: 'track_1',
  title: 'Midnight Dreams',
  artist: 'Electronic Vibes',
  album: 'Synthwave Collection',
  coverUrl: 'https://picsum.photos/400/400?random=1',
  audioUrl: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.wav',
  duration: const Duration(minutes: 3, seconds: 45),
  genres: ['Electronic', 'Synthwave', 'Ambient'],
);