import 'package:flutter/material.dart';

class WeatherTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final TextStyle temperatureStyle;
  final TextStyle conditionStyle;

  const WeatherTheme({
    this.primaryColor = const Color(0xFF2196F3),
    this.backgroundColor = const Color(0xFFE3F2FD),
    this.temperatureStyle = const TextStyle(fontSize: 72, fontWeight: FontWeight.w300),
    this.conditionStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
  });
}

class WeatherScreen extends StatelessWidget {
  final WeatherTheme? theme;
  final WeatherData? data;

  const WeatherScreen({
    Key? key,
    this.theme,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? const WeatherTheme();
    final weather = data ?? _defaultData;

    return Scaffold(
      backgroundColor: effectiveTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.location_on),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weather.location,
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 32),
                  Icon(
                    _getWeatherIcon(weather.condition),
                    size: 120,
                    color: effectiveTheme.primaryColor,
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '${weather.temperature}°',
                    style: effectiveTheme.temperatureStyle,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    weather.condition,
                    style: effectiveTheme.conditionStyle,
                  ),
                ],
              ),
            ),
            _buildDetailsSection(weather, effectiveTheme),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection(WeatherData weather, WeatherTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _DetailItem(
            icon: Icons.air,
            label: 'Wind',
            value: '${weather.wind} km/h',
            color: theme.primaryColor,
          ),
          _DetailItem(
            icon: Icons.water_drop,
            label: 'Humidity',
            value: '${weather.humidity}%',
            color: theme.primaryColor,
          ),
          _DetailItem(
            icon: Icons.visibility,
            label: 'Visibility',
            value: '${weather.visibility} km',
            color: theme.primaryColor,
          ),
        ],
      ),
    );
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
        return Icons.wb_sunny;
      case 'cloudy':
        return Icons.cloud;
      case 'rainy':
        return Icons.umbrella;
      default:
        return Icons.wb_cloudy;
    }
  }

  static final _defaultData = WeatherData(
    location: 'New York',
    temperature: 24,
    condition: 'Sunny',
    wind: 12,
    humidity: 65,
    visibility: 10,
  );
}

class _DetailItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _DetailItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }
}

class WeatherData {
  final String location;
  final int temperature;
  final String condition;
  final int wind;
  final int humidity;
  final int visibility;

  WeatherData({
    required this.location,
    required this.temperature,
    required this.condition,
    required this.wind,
    required this.humidity,
    required this.visibility,
  });
}
