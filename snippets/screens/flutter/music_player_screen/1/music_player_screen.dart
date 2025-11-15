import 'package:flutter/material.dart';

class MusicPlayerTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;

  const MusicPlayerTheme({
    this.backgroundColor = const Color(0xFF1A1A2E),
    this.primaryColor = const Color(0xFF0F3460),
    this.textPrimary = const Color(0xFFEAEAEA),
    this.textSecondary = const Color(0xFF94A3B8),
  });
}

class Track {
  final String title;
  final String artist;
  final String duration;

  const Track({
    required this.title,
    required this.artist,
    required this.duration,
  });
}

class MusicPlayerScreen extends StatefulWidget {
  final MusicPlayerTheme? theme;

  const MusicPlayerScreen({Key? key, this.theme}) : super(key: key);

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isPlaying = false;
  double progress = 0.3;

  final Track currentTrack = const Track(
    title: 'Summer Vibes',
    artist: 'The Artists',
    duration: '3:45',
  );

  MusicPlayerTheme get _theme => widget.theme ?? const MusicPlayerTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        actions: const [
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_theme.primaryColor, _theme.primaryColor.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _theme.primaryColor.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text('🎵', style: TextStyle(fontSize: 100)),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              currentTrack.title,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _theme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentTrack.artist,
              style: TextStyle(
                fontSize: 18,
                color: _theme.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            Slider(
              value: progress,
              onChanged: (value) {
                setState(() => progress = value);
              },
              activeColor: _theme.primaryColor,
              inactiveColor: _theme.textSecondary.withOpacity(0.3),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '1:08',
                    style: TextStyle(color: _theme.textSecondary, fontSize: 12),
                  ),
                  Text(
                    currentTrack.duration,
                    style: TextStyle(color: _theme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.shuffle, color: _theme.textSecondary),
                  iconSize: 28,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.skip_previous, color: _theme.textPrimary),
                  iconSize: 40,
                  onPressed: () {},
                ),
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: _theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    iconSize: 36,
                    onPressed: () {
                      setState(() => isPlaying = !isPlaying);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: _theme.textPrimary),
                  iconSize: 40,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.repeat, color: _theme.textSecondary),
                  iconSize: 28,
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
