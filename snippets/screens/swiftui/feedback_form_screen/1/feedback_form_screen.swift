import SwiftUI

struct FeedbackFormScreen: View {
    @State private var name = ""
    @State private var email = ""
    @State private var feedbackType = FeedbackType.general
    @State private var satisfactionRating = 5.0
    @State private var feedback = ""
    @State private var improvements = ""
    @State private var wouldRecommend = true
    @State private var allowContact = false
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    @Environment(\.presentationMode) var presentationMode

    enum FeedbackType: String, CaseIterable {
        case general = "General"
        case bugReport = "Bug Report"
        case featureRequest = "Feature Request"
        case uiux = "UI/UX"
        case performance = "Performance"
        case support = "Support"
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contact Information")) {
                    HStack {
                        Image(systemName: "person")
                            .foregroundColor(.blue)
                        TextField("Your Name", text: $name)
                    }

                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.blue)
                        TextField("Email Address", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                }

                Section(header: Text("Feedback Details")) {
                    HStack {
                        Image(systemName: "tag")
                            .foregroundColor(.blue)
                        Picker("Feedback Type", selection: $feedbackType) {
                            ForEach(FeedbackType.allCases, id: \.self) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.blue)
                            Text("Overall Satisfaction: \(Int(satisfactionRating))/10")
                        }

                        Slider(value: $satisfactionRating, in: 1...10, step: 1)
                            .accentColor(.blue)

                        HStack {
                            Text("1")
                                .font(.caption)
                                .foregroundColor(.gray)
                            Spacer()
                            Text("10")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right")
                                .foregroundColor(.blue)
                            Text("Your Feedback")
                        }
                        TextEditor(text: $feedback)
                            .frame(minHeight: 100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }

                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "lightbulb")
                                .foregroundColor(.blue)
                            Text("Suggestions for Improvement (Optional)")
                        }
                        TextEditor(text: $improvements)
                            .frame(minHeight: 80)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                }

                Section(header: Text("Additional Questions")) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Would you recommend us to others?")
                            .font(.headline)

                        HStack {
                            Button(action: { wouldRecommend = true }) {
                                HStack {
                                    Image(systemName: wouldRecommend ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(wouldRecommend ? .blue : .gray)
                                    Text("Yes")
                                        .foregroundColor(wouldRecommend ? .blue : .primary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())

                            Spacer()

                            Button(action: { wouldRecommend = false }) {
                                HStack {
                                    Image(systemName: !wouldRecommend ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(!wouldRecommend ? .blue : .gray)
                                    Text("No")
                                        .foregroundColor(!wouldRecommend ? .blue : .primary)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    Toggle("Allow us to contact you for follow-up", isOn: $allowContact)
                }

                Section {
                    Button(action: submitFeedback) {
                        HStack {
                            if isSubmitting {
                                ProgressView()
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "paperplane.fill")
                            }
                            Text("Submit Feedback")
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
            .navigationTitle("Share Feedback")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertMessage.contains("Error") ? "Error" : "Thank You!"),
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
               !feedback.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
               isValidEmail(email)
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func submitFeedback() {
        guard isFormValid() else { return }

        isSubmitting = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isSubmitting = false
            alertMessage = "Thank you for your valuable feedback! We appreciate your input and will use it to improve our services."
            showAlert = true
            clearForm()
        }
    }

    private func clearForm() {
        name = ""
        email = ""
        feedbackType = .general
        satisfactionRating = 5.0
        feedback = ""
        improvements = ""
        wouldRecommend = true
        allowContact = false
    }
}

struct FeedbackFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        FeedbackFormScreen()
    }
}