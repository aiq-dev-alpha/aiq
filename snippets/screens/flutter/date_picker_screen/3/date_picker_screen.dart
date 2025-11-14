import 'package:flutter/material.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({Key? key}) : super(key: key);

  @override
  State<DatePickerScreen> createState() => _DatePickerScreenState();
}

class _DatePickerScreenState extends State<DatePickerScreen> {
  DateTime? _selectedDate;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  TimeOfDay? _selectedTime;
  DateTime? _selectedDateTime;
  String _selectedDateFormat = 'MM/dd/yyyy';
  bool _showCustomPicker = false;

  final List<String> _dateFormats = [
    'MM/dd/yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
    'MMMM dd, yyyy',
    'dd MMMM yyyy',
    'MMM dd, yyyy',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date & Time Picker'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Single Date Picker
            _buildSection(
              title: 'Single Date Selection',
              icon: Icons.calendar_today,
              child: Column(
                children: [
                  _buildDateButton(
                    label: 'Select Date',
                    selectedDate: _selectedDate,
                    onPressed: () => _selectSingleDate(),
                  ),
                  const SizedBox(height: 16),
                  _buildDateFormatSelector(),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date Range Picker
            _buildSection(
              title: 'Date Range Selection',
              icon: Icons.date_range,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateButton(
                          label: 'Start Date',
                          selectedDate: _selectedStartDate,
                          onPressed: () => _selectStartDate(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateButton(
                          label: 'End Date',
                          selectedDate: _selectedEndDate,
                          onPressed: () => _selectEndDate(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _selectDateRange,
                    child: const Text('Select Date Range'),
                  ),
                  if (_selectedStartDate != null && _selectedEndDate != null)
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Duration: ${_selectedEndDate!.difference(_selectedStartDate!).inDays + 1} days',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Time Picker
            _buildSection(
              title: 'Time Selection',
              icon: Icons.access_time,
              child: Column(
                children: [
                  _buildTimeButton(
                    label: 'Select Time',
                    selectedTime: _selectedTime,
                    onPressed: () => _selectTime(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectTime(is24Hour: false),
                          child: const Text('12-Hour Format'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectTime(is24Hour: true),
                          child: const Text('24-Hour Format'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Date and Time Picker
            _buildSection(
              title: 'Date & Time Selection',
              icon: Icons.schedule,
              child: Column(
                children: [
                  _buildDateTimeButton(
                    label: 'Select Date & Time',
                    selectedDateTime: _selectedDateTime,
                    onPressed: () => _selectDateTime(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setToCurrentDateTime(),
                          child: const Text('Current Time'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => _setToTomorrow(),
                          child: const Text('Tomorrow 9 AM'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Custom Date Picker Options
            _buildSection(
              title: 'Custom Date Options',
              icon: Icons.tune,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectPastDate(),
                          child: const Text('Past Dates Only'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectFutureDate(),
                          child: const Text('Future Dates Only'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectWorkingDays(),
                          child: const Text('Working Days'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _selectWeekends(),
                          child: const Text('Weekends Only'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Show Custom Picker'),
                    subtitle: const Text('Use a custom calendar widget'),
                    value: _showCustomPicker,
                    onChanged: (value) => setState(() => _showCustomPicker = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Date Selection
            _buildSection(
              title: 'Quick Date Selection',
              icon: Icons.speed,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildQuickDateChip('Today', DateTime.now()),
                  _buildQuickDateChip('Tomorrow', DateTime.now().add(const Duration(days: 1))),
                  _buildQuickDateChip('Next Week', DateTime.now().add(const Duration(days: 7))),
                  _buildQuickDateChip('Next Month', DateTime.now().add(const Duration(days: 30))),
                  _buildQuickDateChip('New Year', DateTime(DateTime.now().year + 1, 1, 1)),
                  _buildQuickDateChip('Christmas', DateTime(DateTime.now().year, 12, 25)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Summary Card
            if (_hasAnySelection())
              Card(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Selections',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_selectedDate != null)
                        _buildSelectionRow('Selected Date', _formatDate(_selectedDate!)),
                      if (_selectedStartDate != null && _selectedEndDate != null)
                        _buildSelectionRow(
                          'Date Range',
                          '${_formatDate(_selectedStartDate!)} - ${_formatDate(_selectedEndDate!)}',
                        ),
                      if (_selectedTime != null)
                        _buildSelectionRow('Selected Time', _selectedTime!.format(context)),
                      if (_selectedDateTime != null)
                        _buildSelectionRow(
                          'Date & Time',
                          '${_formatDate(_selectedDateTime!)} at ${TimeOfDay.fromDateTime(_selectedDateTime!).format(context)}',
                        ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearAllSelections,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _hasAnySelection() ? _showSelectionDialog : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Confirm Selections'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildDateButton({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: selectedDate != null ? Theme.of(context).primaryColor : Colors.grey,
            width: selectedDate != null ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(label),
            if (selectedDate != null)
              Text(
                _formatDate(selectedDate),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeButton({
    required String label,
    required TimeOfDay? selectedTime,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: selectedTime != null ? Theme.of(context).primaryColor : Colors.grey,
            width: selectedTime != null ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(label),
            if (selectedTime != null)
              Text(
                selectedTime.format(context),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeButton({
    required String label,
    required DateTime? selectedDateTime,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: BorderSide(
            color: selectedDateTime != null ? Theme.of(context).primaryColor : Colors.grey,
            width: selectedDateTime != null ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(label),
            if (selectedDateTime != null)
              Column(
                children: [
                  Text(
                    _formatDate(selectedDateTime),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    TimeOfDay.fromDateTime(selectedDateTime).format(context),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateFormatSelector() {
    return DropdownButtonFormField<String>(
      value: _selectedDateFormat,
      decoration: const InputDecoration(
        labelText: 'Date Format',
        border: OutlineInputBorder(),
      ),
      items: _dateFormats.map((format) => DropdownMenuItem(
        value: format,
        child: Text(format),
      )).toList(),
      onChanged: (value) => setState(() => _selectedDateFormat = value!),
    );
  }

  Widget _buildQuickDateChip(String label, DateTime date) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          _selectedDate = date;
        });
      },
      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
    );
  }

  Widget _buildSelectionRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    switch (_selectedDateFormat) {
      case 'MM/dd/yyyy':
        return '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}';
      case 'dd/MM/yyyy':
        return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      case 'yyyy-MM-dd':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      case 'MMMM dd, yyyy':
        return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
      case 'dd MMMM yyyy':
        return '${date.day} ${_getMonthName(date.month)} ${date.year}';
      case 'MMM dd, yyyy':
        return '${_getMonthAbbreviation(date.month)} ${date.day}, ${date.year}';
      default:
        return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _getMonthAbbreviation(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  bool _hasAnySelection() {
    return _selectedDate != null ||
        (_selectedStartDate != null && _selectedEndDate != null) ||
        _selectedTime != null ||
        _selectedDateTime != null;
  }

  void _selectSingleDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select a date',
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedStartDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: _selectedEndDate ?? DateTime(2100),
      helpText: 'Select start date',
    );
    if (date != null) {
      setState(() => _selectedStartDate = date);
    }
  }

  void _selectEndDate() async {
    final firstDate = _selectedStartDate ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedEndDate ?? firstDate.add(const Duration(days: 1)),
      firstDate: firstDate,
      lastDate: DateTime(2100),
      helpText: 'Select end date',
    );
    if (date != null) {
      setState(() => _selectedEndDate = date);
    }
  }

  void _selectDateRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDateRange: _selectedStartDate != null && _selectedEndDate != null
          ? DateTimeRange(start: _selectedStartDate!, end: _selectedEndDate!)
          : null,
      helpText: 'Select date range',
    );
    if (range != null) {
      setState(() {
        _selectedStartDate = range.start;
        _selectedEndDate = range.end;
      });
    }
  }

  void _selectTime({bool is24Hour = false}) async {
    final time = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: is24Hour,
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _selectedTime = time);
    }
  }

  void _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select date',
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _selectedDateTime != null
            ? TimeOfDay.fromDateTime(_selectedDateTime!)
            : TimeOfDay.now(),
      );

      if (time != null) {
        setState(() {
          _selectedDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _setToCurrentDateTime() {
    setState(() => _selectedDateTime = DateTime.now());
  }

  void _setToTomorrow() {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    setState(() {
      _selectedDateTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 9, 0);
    });
  }

  void _selectPastDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select a past date',
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _selectFutureDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      helpText: 'Select a future date',
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _selectWorkingDays() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select working day (Mon-Fri)',
      selectableDayPredicate: (day) => day.weekday <= 5,
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _selectWeekends() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Select weekend (Sat-Sun)',
      selectableDayPredicate: (day) => day.weekday > 5,
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _clearAllSelections() {
    setState(() {
      _selectedDate = null;
      _selectedStartDate = null;
      _selectedEndDate = null;
      _selectedTime = null;
      _selectedDateTime = null;
    });
  }

  void _showSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selected Dates & Times'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_selectedDate != null)
                Text('Date: ${_formatDate(_selectedDate!)}'),
              if (_selectedStartDate != null && _selectedEndDate != null)
                Text('Range: ${_formatDate(_selectedStartDate!)} - ${_formatDate(_selectedEndDate!)}'),
              if (_selectedTime != null)
                Text('Time: ${_selectedTime!.format(context)}'),
              if (_selectedDateTime != null)
                Text('Date & Time: ${_formatDate(_selectedDateTime!)} at ${TimeOfDay.fromDateTime(_selectedDateTime!).format(context)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}