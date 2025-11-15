import 'package:flutter/material.dart';

class CalendarTheme {
  final Color primaryColor;
  final Color selectedDayColor;
  final Color todayColor;
  final Color weekdayColor;
  final Color eventColor;

  const CalendarTheme({
    this.primaryColor = const Color(0xFF6200EE),
    this.selectedDayColor = const Color(0xFF6200EE),
    this.todayColor = const Color(0xFF03DAC6),
    this.weekdayColor = Colors.black54,
    this.eventColor = const Color(0xFFFF6B6B),
  });
}

class CalendarScreen extends StatefulWidget {
  final CalendarTheme? theme;
  final Map<DateTime, List<CalendarEvent>>? events;

  const CalendarScreen({
    Key? key,
    this.theme,
    this.events,
  }) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selectedDate;
  late DateTime _focusedMonth;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _focusedMonth = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? const CalendarTheme();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        backgroundColor: theme.primaryColor,
      ),
      body: Column(
        children: [
          _buildMonthHeader(theme),
          _buildWeekdayHeaders(theme),
          Expanded(child: _buildCalendarGrid(theme)),
          _buildEventsList(theme),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(CalendarTheme theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () => setState(() {
              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
            }),
          ),
          Text(
            '${_monthName(_focusedMonth.month)} ${_focusedMonth.year}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () => setState(() {
              _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayHeaders(CalendarTheme theme) {
    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: weekdays.map((day) => Expanded(
          child: Text(
            day,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.weekdayColor, fontWeight: FontWeight.w600),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildCalendarGrid(CalendarTheme theme) {
    final daysInMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 0).day;
    final firstDayOfMonth = DateTime(_focusedMonth.year, _focusedMonth.month, 1);
    final startingWeekday = firstDayOfMonth.weekday % 7;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: daysInMonth + startingWeekday,
      itemBuilder: (context, index) {
        if (index < startingWeekday) return const SizedBox();
        final day = index - startingWeekday + 1;
        final date = DateTime(_focusedMonth.year, _focusedMonth.month, day);
        final isToday = _isSameDay(date, DateTime.now());
        final isSelected = _isSameDay(date, _selectedDate);

        return GestureDetector(
          onTap: () => setState(() => _selectedDate = date),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.selectedDayColor
                  : isToday
                      ? theme.todayColor.withOpacity(0.3)
                      : null,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$day',
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventsList(CalendarTheme theme) {
    final events = widget.events?[_selectedDate] ?? [];

    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: events.isEmpty
          ? const Center(child: Text('No events'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: events.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.eventColor,
                  radius: 6,
                ),
                title: Text(events[index].title),
                subtitle: Text(events[index].time),
              ),
            ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _monthName(int month) {
    const months = ['', 'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'];
    return months[month];
  }
}

class CalendarEvent {
  final String title;
  final String time;

  CalendarEvent({required this.title, required this.time});
}
