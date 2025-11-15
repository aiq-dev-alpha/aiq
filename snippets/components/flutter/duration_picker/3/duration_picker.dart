import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Duration initialDuration;
  final Function(Duration)? onDurationChanged;

  const CustomPicker({
    Key? key,
    this.initialDuration = Duration.zero,
    this.onDurationChanged,
  }) : super(key: key);
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  late int _hours;
  late int _minutes;
  late int _seconds;
  @override
  void initState() {
    super.initState();
    _hours = widget.initialDuration.inHours;
    _minutes = widget.initialDuration.inMinutes.remainder(60);
    _seconds = widget.initialDuration.inSeconds.remainder(60);
  }

  void _updateDuration() {
    final duration = Duration(hours: _hours, minutes: _minutes, seconds: _seconds);
    widget.onDurationChanged?.call(duration);
  }

  void _incrementValue(String type) {
    setState(() {
      switch (type) {
        case 'hours':
          _hours = (_hours + 1) % 24;
          break;
        case 'minutes':
          _minutes = (_minutes + 1) % 60;
          break;
        case 'seconds':
          _seconds = (_seconds + 1) % 60;
          break;
      }
    });
    _updateDuration();
  }

  void _decrementValue(String type) {
    setState(() {
      switch (type) {
        case 'hours':
          _hours = _hours > 0 ? _hours - 1 : 23;
          break;
        case 'minutes':
          _minutes = _minutes > 0 ? _minutes - 1 : 59;
          break;
        case 'seconds':
          _seconds = _seconds > 0 ? _seconds - 1 : 59;
          break;
      }
    });
    _updateDuration();
  }

  Widget _buildPickerColumn(String label, int value, String type) {
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: () => _incrementValue(type),
        ),
        Container(
          width: 80,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              value.toString().padLeft(2, '0'),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => _decrementValue(type),
        ),
      ],
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPickerColumn('Hours', _hours, 'hours'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
          _buildPickerColumn('Minutes', _minutes, 'minutes'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
          ),
          _buildPickerColumn('Seconds', _seconds, 'seconds'),
        ],
      ),
    );
  }
}
