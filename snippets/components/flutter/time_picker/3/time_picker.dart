import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final Function(TimeOfDay)? onTimeSelected;
  final bool use24HourFormat;

  const CustomPicker({
    Key? key,
    TimeOfDay? initialTime,
    this.onTimeSelected,
    this.use24HourFormat = false,
  })  : initialTime = initialTime ?? const TimeOfDay(hour: 12, minute: 0),
        super(key: key);
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> {
  late TimeOfDay _selectedTime;
  bool _isAM = true;
  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    _isAM = _selectedTime.hour < 12;
  }

  void _updateTime(int hour, int minute) {
    if (!widget.use24HourFormat && !_isAM && hour < 12) {
      hour += 12;
    }
    setState(() {
      _selectedTime = TimeOfDay(hour: hour, minute: minute);
    });
    widget.onTimeSelected?.call(_selectedTime);
  }
  @override
  Widget build(BuildContext context) {
    final displayHour = widget.use24HourFormat
        ? _selectedTime.hour
        : (_selectedTime.hour % 12 == 0 ? 12 : _selectedTime.hour % 12);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayHour.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Text(
                  _selectedTime.minute.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w300,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                if (!widget.use24HourFormat) ...[
                  const SizedBox(width: 16),
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAM = true;
                            if (_selectedTime.hour >= 12) {
                              _updateTime(_selectedTime.hour - 12, _selectedTime.minute);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isAM ? Theme.of(context).primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'AM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _isAM ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isAM = false;
                            if (_selectedTime.hour < 12) {
                              _updateTime(_selectedTime.hour + 12, _selectedTime.minute);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: !_isAM ? Theme.of(context).primaryColor : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'PM',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: !_isAM ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeColumn(
                'Hour',
                List.generate(widget.use24HourFormat ? 24 : 12,
                    (i) => (widget.use24HourFormat ? i : i + 1).toString().padLeft(2, '0')),
                displayHour - (widget.use24HourFormat ? 0 : 1),
                (value) {
                  final hour = int.parse(value);
                  _updateTime(
                    widget.use24HourFormat ? hour : (hour % 12 + (_isAM ? 0 : 12)),
                    _selectedTime.minute,
                  );
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(':', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
              ),
              _buildTimeColumn(
                'Minute',
                List.generate(60, (i) => i.toString().padLeft(2, '0')),
                _selectedTime.minute,
                (value) {
                  _updateTime(_selectedTime.hour, int.parse(value));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeColumn(
    String label,
    List<String> items,
    int selectedIndex,
    Function(String) onSelect,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 70,
          height: 150,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            controller: FixedExtentScrollController(initialItem: selectedIndex),
            onSelectedItemChanged: (index) => onSelect(items[index]),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                if (index < 0 || index >= items.length) return null;
                final isSelected = index == selectedIndex;
                return Center(
                  child: Text(
                    items[index],
                    style: TextStyle(
                      fontSize: isSelected ? 24 : 18,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade400,
                    ),
                  ),
                );
              },
              childCount: items.length,
            ),
          ),
        ),
      ],
    );
  }
}
