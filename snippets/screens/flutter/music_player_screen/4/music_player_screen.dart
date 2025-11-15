import 'package:flutter/material.dart';

class MusicPlayerTheme {
  final Color backgroundColor;
  final Color accentColor;
  final Color controlsColor;
  final double albumArtSize;

  const MusicPlayerTheme({
    this.backgroundColor = const Color(0xFF1A1A1A),
    this.accentColor = const Color(0xFF1DB954),
    this.controlsColor = Colors.white,
    this.albumArtSize = 280.0,
  });
}

class MusicPlayerScreen extends StatefulWidget {
  final MusicPlayerTheme? theme;
  final Track? currentTrack;

  const MusicPlayerScreen({
    Key? key,
    this.theme,
    this.currentTrack,
  }) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool _isPlaying = false;
  double _progress = 0.3;

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const MusicPlayerTheme();
    final track = widget.currentTrack ?? _defaultTrack;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_down, color: theme.controlsColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: theme.controlsColor),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            Container(
              width: theme.albumArtSize,
              height: theme.albumArtSize,
              decoration: BoxDecoration(
                color: theme.accentColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.music_note, size: 120, color: theme.accentColor),
            ),
            const Spacer(),
            Text(
              track.title,
              style: TextStyle(
                color: theme.controlsColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              track.artist,
              style: TextStyle(
                color: theme.controlsColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            _buildProgressBar(theme),
            const SizedBox(height: 16),
            _buildTimeLabels(track, theme),
            const SizedBox(height: 32),
            _buildControls(theme),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(MusicPlayerTheme theme) {
    return SliderTheme(
      data: SliderThemeData(
        trackHeight: 3,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
        activeTrackColor: theme.accentColor,
        inactiveTrackColor: theme.controlsColor.withOpacity(0.3),
        thumbColor: theme.accentColor,
      ),
      child: Slider(
        value: _progress,
        onChanged: (value) => setState(() => _progress = value),
      ),
    );
  }

  Widget _buildTimeLabels(Track track, MusicPlayerTheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${(_progress * track.duration).toInt()}:${((_progress * track.duration * 60) % 60).toInt().toString().padLeft(2, '0')}',
            style: TextStyle(color: theme.controlsColor.withOpacity(0.7), fontSize: 12),
          ),
          Text(
            '${track.duration}:00',
            style: TextStyle(color: theme.controlsColor.withOpacity(0.7), fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(MusicPlayerTheme theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(Icons.shuffle, color: theme.controlsColor),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.skip_previous, color: theme.controlsColor, size: 36),
          onPressed: () {},
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.accentColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(
              _isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 36,
            ),
            onPressed: () => setState(() => _isPlaying = !_isPlaying),
          ),
        ),
        IconButton(
          icon: Icon(Icons.skip_next, color: theme.controlsColor, size: 36),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.repeat, color: theme.controlsColor),
          onPressed: () {},
        ),
      ],
    );
  }

  static final _defaultTrack = Track(
    title: 'Song Title',
    artist: 'Artist Name',
    duration: 3,
  );
}

class Track {
  final String title;
  final String artist;
  final int duration;

  Track({
    required this.title,
    required this.artist,
    required this.duration,
  });
}
