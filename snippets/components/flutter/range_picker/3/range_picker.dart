import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final double min;
  final double max;
  final double startValue;
  final double endValue;
  final Function(double, double)? onRangeChanged;
  final int divisions;

  const CustomPicker({
    Key? key,
    this.min = 0,
    this.max = 100,
    this.startValue = 20,
    this.endValue = 80,
    this.onRangeChanged,
    this.divisions = 100,
  }) : super(key: key);
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  late RangeValues _currentRange;
  @override
  void initState() {
    super.initState();
    _currentRange = RangeValues(widget.startValue, widget.endValue);
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildValueCard('Min', _currentRange.start),
              const Icon(Icons.arrow_forward, color: Colors.grey),
              _buildValueCard('Max', _currentRange.end),
            ],
          ),
          const SizedBox(height: 24),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Theme.of(context).primaryColor,
              inactiveTrackColor: Theme.of(context).primaryColor.withOpacity(0.2),
              thumbColor: Theme.of(context).primaryColor,
              overlayColor: Theme.of(context).primaryColor.withOpacity(0.2),
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
              trackHeight: 6,
            ),
            child: RangeSlider(
              values: _currentRange,
              min: widget.min,
              max: widget.max,
              divisions: widget.divisions,
              labels: RangeLabels(
                _currentRange.start.round().toString(),
                _currentRange.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRange = values;
                });
                widget.onRangeChanged?.call(values.start, values.end);
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.min.round()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                '${widget.max.round()}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCard(String label, double value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.round().toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
