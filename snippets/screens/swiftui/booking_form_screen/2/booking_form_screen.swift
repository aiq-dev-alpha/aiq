import SwiftUI

struct BookingFormScreen: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var selectedService = Service.consultation
    @State private var selectedDate = Date()
    @State private var selectedTime = Date()
    @State private var duration = Duration.oneHour
    @State private var notes = ""
    @State private var emailReminder = true
    @State private var smsReminder = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    enum Service: String, CaseIterable {
        case consultation = "Consultation"
        case healthCheckup = "Health Checkup"
        case dentalCleaning = "Dental Cleaning"
        case eyeExamination = "Eye Examination"
        case therapySession = "Therapy Session"
        case legalAdvice = "Legal Advice"
        case financialPlanning = "Financial Planning"
    }

    enum Duration: String, CaseIterable {
        case thirtyMin = "30 minutes"
        case oneHour = "1 hour"
        case oneHalfHour = "1.5 hours"
        case twoHours = "2 hours"
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                        TextField("Full Name", text: $name)
                    }

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }

                    HStack {
                        Image(systemName: "phone")
                            .foregroundColor(.blue)
                        TextField("Phone Number", text: $phone)
                            .keyboardType(.phonePad)
                    }
                }

                Section(header: Text("Appointment Details")) {
                    HStack {
                        Image(systemName: "briefcase")
                            .foregroundColor(.blue)
                        Picker("Service", selection: $selectedService) {
                            ForEach(Service.allCases, id: \.self) { service in
                                Text(service.rawValue).tag(service)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    DatePicker(
                        "Date",
                        selection: $selectedDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    DatePicker(
                        "Time",
                        selection: $selectedTime,
                        displayedComponents: .hourAndMinute
                    )
                    .datePickerStyle(CompactDatePickerStyle())

                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        Picker("Duration", selection: $duration) {
                            ForEach(Duration.allCases, id: \.self) { duration in
                                Text(duration.rawValue).tag(duration)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "note.text")
                                .foregroundColor(.blue)
                            Text("Additional Notes (Optional)")
                        }
                        TextEditor(text: $notes)
                            .frame(minHeight: 60)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }

                Section(header: Text("Reminders")) {
                    Toggle("Email reminder (24 hours before)", isOn: $emailReminder)
                    Toggle("SMS reminder (2 hours before)", isOn: $smsReminder)
                }

                Section {
                    Button(action: submitBooking) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "calendar.badge.plus")
                            }
                            Text("Book Appointment")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                    }
                    .disabled(isSubmitting || !isFormValid())
                    .buttonStyle(PrimaryButtonStyle())
                }
            }
            .navigationTitle("Book Appointment")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Booking Confirmed!"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Done")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    private func isFormValid() -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               isValidEmail(email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func submitBooking() {
        guard isFormValid() else { return }

        isSubmitting = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false

            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short

            alertMessage = """
            Your appointment has been successfully booked:

            Service: \(selectedService.rawValue)
            Date: \(formatter.string(from: selectedDate))
            Duration: \(duration.rawValue)
            """
            showAlert = true
        }
    }
}

struct BookingFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        BookingFormScreen()
    }
}