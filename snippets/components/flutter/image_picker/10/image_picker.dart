import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final Color primaryColor;
  final Function(dynamic)? onPicked;
  final String label;
  
  const CustomPicker({
    Key? key,
    this.primaryColor = const Color(0xFF6200EE),
    this.onPicked,
    this.label = 'Pick',
  }) : super(key: key);

  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  String _selected = 'Not selected';

  void _showPicker() async {
    setState(() => _selected = 'Selected');
    widget.onPicked?.call(_selected);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: _showPicker,
      style: OutlinedButton.styleFrom(
        foregroundColor: widget.primaryColor,
        side: BorderSide(color: widget.primaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 18),
          const SizedBox(width: 8),
          Text(_selected),
        ],
      ),
    );
  }
}
