import 'package:flutter/material.dart';

class CalendarScreenTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final Color selectedDayColor;
  final Color todayColor;
  final Color textColor;
  final Color eventColor;

  const CalendarScreenTheme({
    this.backgroundColor = const Color(0xFFFAFAFA),
    this.primaryColor = const Color(0xFF3B82F6),
    this.selectedDayColor = const Color(0xFF3B82F6),
    this.todayColor = const Color(0xFFEFF6FF),
    this.textColor = const Color(0xFF111827),
    this.eventColor = const Color(0xFF10B981),
  });
}

class CalendarEvent {
  final String id;
  final String title;
  final DateTime date;
  final Color color;

  const CalendarEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.color,
  });
}

class CalendarScreen extends StatefulWidget {
  final CalendarScreenTheme? theme;

  const CalendarScreen({Key? key, this.theme}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedMonth = DateTime.now();
  final List<CalendarEvent> _events = [
    CalendarEvent(
      id: '1',
      title: 'Team Meeting',
      date: DateTime.now(),
      color: const Color(0xFF3B82F6),
    ),
    CalendarEvent(
      id: '2',
      title: 'Project Deadline',
      date: DateTime.now().add(const Duration(days: 2)),
      color: const Color(0xFFEF4444),
    ),
  ];

  CalendarScreenTheme get _theme => widget.theme ?? const CalendarScreenTheme();

  List<CalendarEvent> _getEventsForDay(DateTime day) {
    return _events.where((event) =>
      event.date.year == day.year &&
      event.date.month == day.month &&
      event.date.day == day.day
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: _theme.primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
                _focusedMonth = DateTime.now();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month - 1,
                          );
                        });
                      },
                    ),
                    Text(
                      '${_getMonthName(_focusedMonth.month)} ${_focusedMonth.year}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _theme.textColor,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: () {
                        setState(() {
                          _focusedMonth = DateTime(
                            _focusedMonth.year,
                            _focusedMonth.month + 1,
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _CalendarGrid(
                  focusedMonth: _focusedMonth,
                  selectedDate: _selectedDate,
                  onDateSelected: (date) {
                    setState(() => _selectedDate = date);
                  },
                  theme: _theme,
                  events: _events,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Events for ${_selectedDate.day} ${_getMonthName(_selectedDate.month)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _theme.textColor,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _getEventsForDay(_selectedDate).isEmpty
                        ? Center(
                            child: Text(
                              'No events scheduled',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _getEventsForDay(_selectedDate).length,
                            itemBuilder: (context, index) {
                              final event = _getEventsForDay(_selectedDate)[index];
                              return ListTile(
                                leading: Container(
                                  width: 4,
                                  height: 40,
                                  color: event.color,
                                ),
                                title: Text(event.title),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final CalendarScreenTheme theme;
  final List<CalendarEvent> events;

  const _CalendarGrid({
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.theme,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final daysInMonth = lastDayOfMonth.day;
    final startWeekday = firstDayOfMonth.weekday % 7;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((day) => Expanded(
                    child: Center(
                      child: Text(
                        day,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 1,
          ),
          itemCount: 42,
          itemBuilder: (context, index) {
            final dayNumber = index - startWeekday + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox();
            }

            final date = DateTime(focusedMonth.year, focusedMonth.month, dayNumber);
            final isSelected = date.year == selectedDate.year &&
                date.month == selectedDate.month &&
                date.day == selectedDate.day;
            final isToday = date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day;

            return GestureDetector(
              onTap: () => onDateSelected(date),
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.selectedDayColor
                      : isToday
                          ? theme.todayColor
                          : null,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$dayNumber',
                    style: TextStyle(
                      color: isSelected ? Colors.white : theme.textColor,
                      fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
