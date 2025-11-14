import SwiftUI

struct ContactFormScreen: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var subject = ""
    @State private var message = ""
    @State private var priority = Priority.medium
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    enum Priority: String, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
        case urgent = "Urgent"
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
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
                        TextField("Phone Number (Optional)", text: $phone)
                            .keyboardType(.phonePad)
                    }
                }

                Section(header: Text("Message Details")) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.blue)
                        Picker("Priority", selection: $priority) {
                            ForEach(Priority.allCases, id: \.self) { priority in
                                Text(priority.rawValue).tag(priority)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    HStack {
                        Image(systemName: "text.quote")
                            .foregroundColor(.blue)
                        TextField("Subject", text: $subject)
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "message")
                                .foregroundColor(.blue)
                            Text("Message")
                                .foregroundColor(.primary)
                        }
                        TextEditor(text: $message)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }

                Section {
                    Button(action: submitForm) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "paperplane.fill")
                            }
                            Text("Send Message")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                    }
                    .disabled(isSubmitting || !isFormValid())
                    .buttonStyle(PrimaryButtonStyle())

                    Button("Clear Form") {
                        clearForm()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Contact Us")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage.contains("Error") ? "Error" : "Success"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if !alertMessage.contains("Error") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }

    private func isFormValid() -> Bool {
        return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               isValidEmail(email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func submitForm() {
        guard isFormValid() else { return }

        isSubmitting = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            alertMessage = "Thank you for contacting us! We'll get back to you soon."
            showAlert = true
            clearForm()
        }
    }

    private func clearForm() {
        name = ""
        email = ""
        phone = ""
        subject = ""
        message = ""
        priority = .medium
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ContactFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        ContactFormScreen()
    }
}