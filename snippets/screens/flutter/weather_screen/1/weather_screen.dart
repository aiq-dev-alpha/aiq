import 'package:flutter/material.dart';

class WeatherScreenTheme {
  final Color backgroundColor;
  final Color cardBackground;
  final Color primaryColor;
  final Color textPrimary;

  const WeatherScreenTheme({
    this.backgroundColor = const Color(0xFF4A90E2),
    this.cardBackground = const Color(0xFFFFFFFF),
    this.primaryColor = const Color(0xFF2C3E50),
    this.textPrimary = const Color(0xFF2C3E50),
  });
}

class WeatherScreen extends StatelessWidget {
  final WeatherScreenTheme? theme;

  const WeatherScreen({Key? key, this.theme}) : super(key: key);

  WeatherScreenTheme get _theme => theme ?? const WeatherScreenTheme();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_theme.backgroundColor, _theme.backgroundColor.withOpacity(0.6)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'San Francisco',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w300, color: Colors.white),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Monday, 3:00 PM',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      const Text(
                        '☀️',
                        style: TextStyle(fontSize: 120),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '72°',
                        style: TextStyle(fontSize: 80, fontWeight: FontWeight.w200, color: Colors.white),
                      ),
                      const Text(
                        'Sunny',
                        style: TextStyle(fontSize: 24, color: Colors.white70),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _WeatherDetail('💧', 'Humidity', '45%'),
                          _WeatherDetail('💨', 'Wind', '12 mph'),
                          _WeatherDetail('🌡', 'Feels Like', '70°'),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _ForecastItem('Mon', '☀️', '72°'),
                      _ForecastItem('Tue', '⛅', '68°'),
                      _ForecastItem('Wed', '🌧', '62°'),
                      _ForecastItem('Thu', '☁️', '65°'),
                      _ForecastItem('Fri', '☀️', '74°'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WeatherDetail extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _WeatherDetail(this.icon, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}

class _ForecastItem extends StatelessWidget {
  final String day;
  final String icon;
  final String temp;

  const _ForecastItem(this.day, this.icon, this.temp);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(day, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 8),
        Text(icon, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(temp, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      ],
    );
  }
}
