import SwiftUI

struct DatePickerScreen: View {
    @State private var selectedDate = Date()
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(86400)
    @State private var selectedTime = Date()
    @State private var selectedDateTime = Date()
    @State private var showingDatePicker = false
    @State private var datePickerType: DatePickerType = .single

    @Environment(\.presentationMode) var presentationMode

    enum DatePickerType {
        case single, range, time, dateTime, past, future, weekdays
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Single Date Selection")) {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    Button("Today") {
                        selectedDate = Date()
                    }
                    .foregroundColor(.blue)

                    Button("Tomorrow") {
                        selectedDate = Date().addingTimeInterval(86400)
                    }
                    .foregroundColor(.blue)

                    Text("Selected: \(formatDate(selectedDate))")
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Date Range Selection")) {
                    DatePicker(
                        "Start Date",
                        selection: $startDate,
                        in: ...endDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    DatePicker(
                        "End Date",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    let days = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
                    Text("Duration: \(days + 1) day(s)")
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Time Selection")) {
                    DatePicker(
                        "Select Time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(WheelDatePickerStyle())

                    Text("Selected: \(formatTime(selectedTime))")
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Date & Time Selection")) {
                    DatePicker(
                        "Select Date & Time",
                        selection: $selectedDateTime,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    Button("Set to Now") {
                        selectedDateTime = Date()
                    }
                    .foregroundColor(.blue)

                    Button("Set to Tomorrow 9 AM") {
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
                        selectedDateTime = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: tomorrow)!
                    }
                    .foregroundColor(.blue)

                    Text("Selected: \(formatDateTime(selectedDateTime))")
                        .foregroundColor(.secondary)
                }

                Section(header: Text("Custom Date Options")) {
                    Button("Past Dates Only") {
                        datePickerType = .past
                        showingDatePicker = true
                    }

                    Button("Future Dates Only") {
                        datePickerType = .future
                        showingDatePicker = true
                    }

                    Button("Working Days Only") {
                        datePickerType = .weekdays
                        showingDatePicker = true
                    }
                }

                Section(header: Text("Quick Date Selection")) {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        QuickDateButton(title: "Today", date: Date()) { selectedDate = $0 }
                        QuickDateButton(title: "Tomorrow", date: Date().addingTimeInterval(86400)) { selectedDate = $0 }
                        QuickDateButton(title: "Next Week", date: Date().addingTimeInterval(604800)) { selectedDate = $0 }
                        QuickDateButton(title: "Next Month", date: Calendar.current.date(byAdding: .month, value: 1, to: Date())!) { selectedDate = $0 }
                        QuickDateButton(title: "New Year", date: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()) + 1, month: 1, day: 1))!) { selectedDate = $0 }
                        QuickDateButton(title: "Christmas", date: Calendar.current.date(from: DateComponents(year: Calendar.current.component(.year, from: Date()), month: 12, day: 25))!) { selectedDate = $0 }
                    }
                }

                Section(header: Text("Your Selections")) {
                    VStack(alignment: .leading, spacing: 8) {
                        SelectionRow(label: "Selected Date", value: formatDate(selectedDate))
                        SelectionRow(label: "Date Range", value: "\(formatDate(startDate)) - \(formatDate(endDate))")
                        SelectionRow(label: "Selected Time", value: formatTime(selectedTime))
                        SelectionRow(label: "Date & Time", value: formatDateTime(selectedDateTime))
                    }
                }

                Section {
                    Button("Clear All Selections") {
                        clearAllSelections()
                    }
                    .foregroundColor(.red)

                    Button("Confirm Selections") {
                        showConfirmationAlert()
                    }
                    .foregroundColor(.blue)
                }
            }
            .navigationTitle("Date & Time Picker")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
            .sheet(isPresented: $showingDatePicker) {
                customDatePickerSheet
            }
        }
    }

    private var customDatePickerSheet: some View {
        NavigationView {
            VStack {
                Text(datePickerTitle)
                    .font(.headline)
                    .padding()

                DatePicker(
                    "Select Date",
                    selection: $selectedDate,
                    in: dateRange,
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()

                Spacer()
            }
            .navigationTitle("Select Date")
            .navigationBarItems(
                leading: Button("Cancel") {
                    showingDatePicker = false
                },
                trailing: Button("Done") {
                    showingDatePicker = false
                }
            )
        }
    }

    private var datePickerTitle: String {
        switch datePickerType {
        case .past:
            return "Select a past date"
        case .future:
            return "Select a future date"
        case .weekdays:
            return "Select a working day (Mon-Fri)"
        default:
            return "Select a date"
        }
    }

    private var dateRange: PartialRangeThrough<Date> {
        switch datePickerType {
        case .past:
            return ...Date()
        case .future:
            return Date()...
        default:
            return Date(timeIntervalSince1970: 0)...
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func formatDateTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private func clearAllSelections() {
        selectedDate = Date()
        startDate = Date()
        endDate = Date().addingTimeInterval(86400)
        selectedTime = Date()
        selectedDateTime = Date()
    }

    private func showConfirmationAlert() {
        // This would typically show an alert or perform some action
        print("Selections confirmed!")
    }
}

struct QuickDateButton: View {
    let title: String
    let date: Date
    let action: (Date) -> Void

    var body: some View {
        Button(title) {
            action(date)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
        .foregroundColor(.blue)
    }
}

struct SelectionRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text("\(label):")
                .fontWeight(.semibold)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct DatePickerScreen_Previews: PreviewProvider {
    static var previews: some View {
        DatePickerScreen()
    }
}