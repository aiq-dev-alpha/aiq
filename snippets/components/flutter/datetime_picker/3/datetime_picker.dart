import 'package:flutter/material.dart';

class CustomPicker extends StatefulWidget {
  final DateTime? initialDateTime;
  final Function(DateTime)? onDateTimeSelected;

  const CustomPicker({
    Key? key,
    this.initialDateTime,
    this.onDateTimeSelected,
  }) : super(key: key);
  @override
  State<CustomPicker> createState() => _CustomPickerState();
}

class _CustomPickerState extends State<CustomPicker> with SingleTickerProviderStateMixin {
  late DateTime _selectedDateTime;
  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
    _tabController = TabController(length: 2, vsync: this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _updateTime(int hours, int minutes) {
    setState(() {
      _selectedDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month,
        _selectedDateTime.day,
        hours,
        minutes,
      );
    });
    widget.onDateTimeSelected?.call(_selectedDateTime);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
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
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              children: [
                Text(
                  '${_selectedDateTime.year}/${_selectedDateTime.month.toString().padLeft(2, '0')}/${_selectedDateTime.day.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_selectedDateTime.hour.toString().padLeft(2, '0')}:${_selectedDateTime.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).primaryColor,
            unselectedLabelColor: Colors.grey.shade600,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: const [
              Tab(text: 'Date'),
              Tab(text: 'Time'),
            ],
          ),
          SizedBox(
            height: 250,
            child: TabBarView(
              controller: _tabController,
              children: [
                CalendarDatePicker(
                  initialDate: _selectedDateTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDateTime = DateTime(
                        date.year,
                        date.month,
                        date.day,
                        _selectedDateTime.hour,
                        _selectedDateTime.minute,
                      );
                    });
                    widget.onDateTimeSelected?.call(_selectedDateTime);
                  },
                ),
                TimePickerSpinner(
                  time: _selectedDateTime,
                  onTimeChange: _updateTime,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TimePickerSpinner extends StatelessWidget {
  final DateTime time;
  final Function(int, int) onTimeChange;

  const TimePickerSpinner({
    Key? key,
    required this.time,
    required this.onTimeChange,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColumn(
          List.generate(24, (i) => i.toString().padLeft(2, '0')),
          time.hour,
          (value) => onTimeChange(int.parse(value), time.minute),
        ),
        const Text(':', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
        _buildColumn(
          List.generate(60, (i) => i.toString().padLeft(2, '0')),
          time.minute,
          (value) => onTimeChange(time.hour, int.parse(value)),
        ),
      ],
    );
  }

  Widget _buildColumn(List<String> items, int selectedIndex, Function(String) onSelect) {
    return SizedBox(
      width: 60,
      height: 200,
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
                  color: isSelected ? Colors.black : Colors.grey.shade400,
                ),
              ),
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}
