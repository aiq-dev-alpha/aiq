import SwiftUI

struct RegistrationFormScreen: View {
    @State private var currentStep = 0
    @State private var isSubmitting = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Step 1: Basic Information
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var dateOfBirth = Date()
    @State private var gender = Gender.preferNotToSay

    // Step 2: Account Details
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    // Step 3: Address Information
    @State private var street = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    @State private var country = "United States"

    // Step 4: Preferences
    @State private var marketingEmails = false
    @State private var pushNotifications = true
    @State private var termsAccepted = false
    @State private var privacyAccepted = false
    @State private var preferredLanguage = "English"

    @Environment(\.presentationMode) var presentationMode

    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case other = "Other"
        case preferNotToSay = "Prefer not to say"
    }

    let countries = ["United States", "Canada", "United Kingdom", "Australia", "Other"]
    let languages = ["English", "Spanish", "French", "German", "Chinese"]

    var body: some View {
        NavigationView {
            VStack {
                // Progress indicator
                ProgressView(value: Double(currentStep + 1), total: 4)
                    .progressViewStyle(LinearProgressViewStyle())
                    .padding()

                HStack {
                    ForEach(0..<4) { step in
                        VStack {
                            Circle()
                                .fill(step <= currentStep ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("\(step + 1)")
                                        .foregroundColor(.white)
                                        .fontWeight(.bold)
                                )
                            Text(stepTitle(for: step))
                                .font(.caption)
                                .multilineTextAlignment(.center)
                        }
                        if step < 3 {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)

                ScrollView {
                    stepContent
                        .padding()
                }

                // Navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation {
                                currentStep -= 1
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }

                    Spacer()

                    Button(currentStep == 3 ? "Create Account" : "Next") {
                        if currentStep == 3 {
                            submitRegistration()
                        } else {
                            withAnimation {
                                currentStep += 1
                            }
                        }
                    }
                    .disabled(!isCurrentStepValid() || isSubmitting)
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding()
            }
            .navigationTitle("Create Account")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Registration Successful!"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Continue")) {
                        presentationMode.wrappedValue.dismiss()
                    }
                )
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        switch currentStep {
        case 0:
            basicInformationStep
        case 1:
            accountDetailsStep
        case 2:
            addressInformationStep
        case 3:
            preferencesStep
        default:
            EmptyView()
        }
    }

    private var basicInformationStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Basic Information")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }

            TextField("Email Address", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            TextField("Phone Number", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)

            DatePicker(
                "Date of Birth",
                selection: $dateOfBirth,
                in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!,
                displayedComponents: .date
            )
            .datePickerStyle(CompactDatePickerStyle())

            Picker("Gender", selection: $gender) {
                ForEach(Gender.allCases, id: \.self) { gender in
                    Text(gender.rawValue).tag(gender)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    private var accountDetailsStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Account Details")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Text("Password must be at least 8 characters and include uppercase, lowercase, and number")
                .font(.caption)
                .foregroundColor(.gray)
        }
    }

    private var addressInformationStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Address Information")
                .font(.title2)
                .fontWeight(.bold)

            TextField("Street Address", text: $street)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                TextField("City", text: $city)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("State", text: $state)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("ZIP", text: $zipCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
            }

            Picker("Country", selection: $country) {
                ForEach(countries, id: \.self) { country in
                    Text(country).tag(country)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
    }

    private var preferencesStep: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Preferences & Terms")
                .font(.title2)
                .fontWeight(.bold)

            Picker("Preferred Language", selection: $preferredLanguage) {
                ForEach(languages, id: \.self) { language in
                    Text(language).tag(language)
                }
            }
            .pickerStyle(MenuPickerStyle())

            VStack(alignment: .leading, spacing: 8) {
                Text("Notification Preferences")
                    .font(.headline)

                Toggle("Marketing emails", isOn: $marketingEmails)
                Toggle("Push notifications", isOn: $pushNotifications)
            }

            VStack(alignment: .leading, spacing: 8) {
                Toggle("I accept the Terms of Service", isOn: $termsAccepted)
                Toggle("I accept the Privacy Policy", isOn: $privacyAccepted)
            }
        }
    }

    private func stepTitle(for step: Int) -> String {
        switch step {
        case 0: return "Basic"
        case 1: return "Account"
        case 2: return "Address"
        case 3: return "Finish"
        default: return ""
        }
    }

    private func isCurrentStepValid() -> Bool {
        switch currentStep {
        case 0:
            return !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty && !phone.isEmpty && isValidEmail(email)
        case 1:
            return !username.isEmpty && username.count >= 3 && isValidPassword(password) && password == confirmPassword
        case 2:
            return !street.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
        case 3:
            return termsAccepted && privacyAccepted
        default:
            return false
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 8 &&
               password.rangeOfCharacter(from: .uppercaseLetters) != nil &&
               password.rangeOfCharacter(from: .lowercaseLetters) != nil &&
               password.rangeOfCharacter(from: .decimalDigits) != nil
    }

    private func submitRegistration() {
        guard isCurrentStepValid() else { return }

        isSubmitting = true

        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isSubmitting = false
            alertMessage = "Welcome! Your account has been created successfully. Please check your email to verify your account."
            showAlert = true
        }
    }
}

struct RegistrationFormScreen_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationFormScreen()
    }
}